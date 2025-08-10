import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchAndFilters extends ConsumerStatefulWidget {
  final String searchQuery;
  final List<String> selectedTags;
  final List<String> selectedCuisines;
  final int? minCalories;
  final int? maxCalories;
  final List<String> availableTags;
  final List<String> availableCuisines;
  final Function(String) onSearchChanged;
  final Function(String) onTagToggled;
  final Function(String) onCuisineToggled;
  final Function(int?, int?) onCalorieRangeChanged;
  final VoidCallback onClearFilters;

  const SearchAndFilters({
    super.key,
    required this.searchQuery,
    required this.selectedTags,
    required this.selectedCuisines,
    required this.minCalories,
    required this.maxCalories,
    required this.availableTags,
    required this.availableCuisines,
    required this.onSearchChanged,
    required this.onTagToggled,
    required this.onCuisineToggled,
    required this.onCalorieRangeChanged,
    required this.onClearFilters,
  });

  @override
  ConsumerState<SearchAndFilters> createState() => _SearchAndFiltersState();
}

class _SearchAndFiltersState extends ConsumerState<SearchAndFilters> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
  }

  @override
  void didUpdateWidget(SearchAndFilters oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search meals...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
            ),
            onChanged: widget.onSearchChanged,
          ),
        ),

        // Filters section
        if (_showFilters) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onClearFilters,
                      child: const Text('Clear All'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tags filter
                if (widget.availableTags.isNotEmpty) ...[
                  Text(
                    'Tags',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: widget.availableTags.map((tag) {
                      final isSelected = widget.selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (_) => widget.onTagToggled(tag),
                        selectedColor:
                            theme.colorScheme.primary.withValues(alpha: 0.2),
                        checkmarkColor: theme.colorScheme.primary,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Cuisine filter
                if (widget.availableCuisines.isNotEmpty) ...[
                  Text(
                    'Cuisine',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: widget.availableCuisines.map((cuisine) {
                      final isSelected =
                          widget.selectedCuisines.contains(cuisine);
                      return FilterChip(
                        label: Text(cuisine),
                        selected: isSelected,
                        onSelected: (_) => widget.onCuisineToggled(cuisine),
                        selectedColor:
                            theme.colorScheme.primary.withValues(alpha: 0.2),
                        checkmarkColor: theme.colorScheme.primary,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Calorie range filter
                Text(
                  'Calorie Range',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Min',
                          suffixText: 'cal',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final min = int.tryParse(value);
                          widget.onCalorieRangeChanged(min, widget.maxCalories);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Max',
                          suffixText: 'cal',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final max = int.tryParse(value);
                          widget.onCalorieRangeChanged(widget.minCalories, max);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
