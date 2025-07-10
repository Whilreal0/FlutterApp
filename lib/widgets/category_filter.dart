import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const CategoryFilter({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Mountain', 'Sea', 'Historical', 'Cultural', 'Religious'];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selected == cat;
          return GestureDetector(
            onTap: () => onChanged(cat),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.teal : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 15
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}