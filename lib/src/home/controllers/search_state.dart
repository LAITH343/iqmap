import 'package:flutter/material.dart';
import 'package:iqmap/src/home/controllers/search_items.dart';

@immutable
final class const SearchState({
  final String query = '',
  final List<SearchItems> items = const [],
  final SearchItems? selected,
  final bool isOpen = false,
  // Bumped on every selection so re-selecting the same place still recenters
  // the map after the user has panned away.
  final int selectionId = 0,
}) {
  bool get hasResults => items.isNotEmpty;

  bool get showNoResults => isOpen && query.trim().isNotEmpty && items.isEmpty;

  SearchState copyWith({
    String? query,
    List<SearchItems>? items,
    SearchItems? Function()? selected,
    bool? isOpen,
    int? selectionId,
  }) => SearchState(
    query: query ?? this.query,
    items: items ?? this.items,
    selected: selected != null ? selected() : this.selected,
    isOpen: isOpen ?? this.isOpen,
    selectionId: selectionId ?? this.selectionId,
  );
}
