import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const CategoryFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      'River',
      'Beach',
      'Industrial',
      'Mountain',
      'Historical',
      'Cultural',
      'Religious',
      'Farm',
    ];

    return SizedBox(
      height: 40, // slightly smaller height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selected.toLowerCase() == category.toLowerCase();

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 12, // smaller text
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onChanged(category),
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.teal,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ), // tight padding
              visualDensity: VisualDensity.compact, // tighter spacing overall
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          );
        },
      ),
    );
  }
}
