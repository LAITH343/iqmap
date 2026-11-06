import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iqmap/src/home/controllers/search_items.dart';
import 'package:iqmap/src/home/controllers/search_notifier.dart';
import 'package:iqmap/src/home/domain/entities/coordinates.dart';
import 'package:iqmap/src/home/widgets/search_for_locations.dart';

const _erbil = SearchItems(
  labelAr: 'أربيل',
  labelEn: 'Erbil',
  coordinates: Coordinates(lat: 36.19, lng: 44.00),
);
const _basra = SearchItems(
  labelAr: 'البصرة',
  labelEn: 'Basra',
  coordinates: Coordinates(lat: 30.50, lng: 47.78),
);

final _overrides = [
  locationProvider.overrideWithValue(const [_erbil, _basra]),
];

void main() {
  group('SearchNotifier', () {
    late ProviderContainer container;
    late SearchNotifier notifier;

    setUp(() {
      container = ProviderContainer.test(overrides: _overrides);
      // searchProvider is autoDispose, so it needs a listener to stay alive.
      container.listen(searchProvider, (_, _) {});
      notifier = container.read(searchProvider.notifier);
    });

    List<SearchItems> search(String query) {
      notifier.onQueryChanged(query);
      return container.read(searchProvider).items;
    }

    test('matches English case-insensitively', () {
      expect(search('ERB'), [_erbil]);
    });

    test('matches Arabic labels', () {
      expect(search('أربيل'), [_erbil]);
      expect(search('البصرة'), [_basra]);
    });

    test('a blank query has no results and no empty state', () {
      expect(search('   '), isEmpty);
      expect(container.read(searchProvider).showNoResults, isFalse);
    });

    test('an unmatched query shows the empty state', () {
      expect(search('zzz'), isEmpty);
      expect(container.read(searchProvider).showNoResults, isTrue);
    });

    test('selecting closes results and reopening uses the shown text', () {
      search('erb');
      notifier.select(_erbil, query: 'Erbil');

      var state = container.read(searchProvider);
      expect(state.selected, _erbil);
      expect(state.hasResults, isFalse);
      expect(state.showNoResults, isFalse);

      notifier.showResults();
      state = container.read(searchProvider);
      expect(state.items, [_erbil]);
    });

    test('re-selecting the same place produces a new selectionId', () {
      notifier.select(_erbil, query: 'Erbil');
      final first = container.read(searchProvider).selectionId;
      notifier.select(_erbil, query: 'Erbil');
      expect(container.read(searchProvider).selectionId, isNot(first));
    });

    test('hiding results keeps the selection', () {
      notifier.select(_erbil, query: 'Erbil');
      notifier.hideResults();
      expect(container.read(searchProvider).selected, _erbil);
    });

    test('emptying the field drops the selection', () {
      notifier.select(_erbil, query: 'Erbil');
      notifier.onQueryChanged('');
      expect(container.read(searchProvider).selected, isNull);
    });
  });

  group('SearchForLocations', () {
    late ProviderContainer container;

    Future<void> pump(WidgetTester tester) async {
      container = ProviderContainer.test(overrides: _overrides);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: SearchForLocations())),
        ),
      );
    }

    testWidgets('typing then tapping a result selects it', (tester) async {
      await pump(tester);

      await tester.enterText(find.byType(TextField), 'bas');
      await tester.pump();
      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(container.read(searchProvider).selected, _basra);
      expect(find.byType(ListTile), findsNothing);
      expect(find.widgetWithText(TextField, 'Basra'), findsOneWidget);
    });

    testWidgets('submitting selects the first result', (tester) async {
      await pump(tester);

      await tester.enterText(find.byType(TextField), 'erb');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(container.read(searchProvider).selected, _erbil);
    });

    testWidgets('shows a message when nothing matches', (tester) async {
      await pump(tester);

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump();

      expect(find.text('No locations found'), findsOneWidget);
    });

    testWidgets('the clear button resets the search', (tester) async {
      await pump(tester);

      await tester.enterText(find.byType(TextField), 'erb');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(container.read(searchProvider).query, isEmpty);
      expect(find.byType(ListTile), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
    });
  });
}
