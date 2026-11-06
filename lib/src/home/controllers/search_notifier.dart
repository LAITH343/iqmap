import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iqmap/src/home/controllers/search_items.dart';
import 'package:iqmap/src/home/controllers/search_state.dart';
import 'package:iqmap/src/home/data/iraq_locations.dart';

final locationProvider = Provider<List<SearchItems>>((ref) => iraqLocations);

final searchProvider =
    NotifierProvider.autoDispose<SearchNotifier, SearchState>(
      SearchNotifier.new,
    );

class SearchNotifier extends Notifier<SearchState> {
  @override
  SearchState build() {
    ref.watch(locationProvider);
    return const SearchState();
  }

  void onQueryChanged(String value) {
    state = state.copyWith(
      query: value,
      items: _filter(value),
      isOpen: true,
      selected: value.isEmpty ? () => null : null,
    );
  }

  void showResults() {
    state = state.copyWith(items: _filter(state.query), isOpen: true);
  }

  void hideResults() {
    state = state.copyWith(items: const [], isOpen: false);
  }

  void select(SearchItems item, {required String query}) {
    state = state.copyWith(
      query: query,
      items: const [],
      isOpen: false,
      selected: () => item,
      selectionId: state.selectionId + 1,
    );
  }

  void clear() {
    state = const SearchState();
  }

  List<SearchItems> _filter(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) return const [];

    return ref
        .read(locationProvider)
        .where(
          (item) =>
              item.labelEn.toLowerCase().contains(q) ||
              item.labelAr.contains(q),
        )
        .toList(growable: false);
  }
}
