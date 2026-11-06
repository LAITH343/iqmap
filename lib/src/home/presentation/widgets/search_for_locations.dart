import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iqmap/src/home/domain/entities/search_items.dart';
import 'package:iqmap/src/home/presentation/controllers/location_search_controller.dart';

class SearchForLocations extends ConsumerStatefulWidget {
  const SearchForLocations({super.key});

  @override
  ConsumerState<SearchForLocations> createState() => _SearchForLocationsState();
}

class _SearchForLocationsState extends ConsumerState<SearchForLocations> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
  );

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSelect(SearchItems item) {
    _searchController.text = item.labelEn;
    _searchFocusNode.unfocus();
    ref
        .read(locationSearchControllerProvider.notifier)
        .select(item, query: item.labelEn);
  }

  void _onSubmitted(String _) {
    final items = ref.read(locationSearchControllerProvider).items;
    if (items.isNotEmpty) _onSelect(items.first);
  }

  void _onClear() {
    _searchController.clear();
    ref.read(locationSearchControllerProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(locationSearchControllerProvider);
    final notifier = ref.read(locationSearchControllerProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search bar
        Container(
          height: 56,
          decoration: _cardDecoration,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.search),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: notifier.onQueryChanged,
                  onTap: notifier.showResults,
                  onSubmitted: _onSubmitted,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Search locations',
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (search.query.isNotEmpty)
                IconButton(icon: const Icon(Icons.close), onPressed: _onClear),
            ],
          ),
        ),

        // Results
        if (search.hasResults)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: _cardDecoration,
            clipBehavior: Clip.antiAlias,
            child: Material(
              type: MaterialType.transparency,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: search.items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final item = search.items[i];
                  return ListTile(
                    leading: const Icon(Icons.place_outlined),
                    title: Text(item.labelEn),
                    subtitle: Text(
                      item.labelAr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _onSelect(item),
                  );
                },
              ),
            ),
          ),

        if (search.showNoResults)
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration,
            child: const Text('No locations found'),
          ),
      ],
    );
  }
}
