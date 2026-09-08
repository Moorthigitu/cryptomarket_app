import 'package:flutter/material.dart';
import 'package:cryptomarket/theme/app_theme.dart';

class FilterChipsRow extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;
  final List<String> filters;

  const FilterChipsRow({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.filters = const ['All', 'Gainers', 'Losers', 'Top Volume'],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;

          return GestureDetector(
            onTap: () => onFilterSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accentGold : AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                border: Border.all(
                  color: isSelected ? AppTheme.accentGold : AppTheme.border,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: AppTheme.bodyStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.black : AppTheme.textMuted,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
