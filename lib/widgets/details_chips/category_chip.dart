// lib/widgets/details_chips/category_chip.dart
// Reusable, border‑less, emoji‑enhanced category chip.

import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String? category;
  final EdgeInsets labelPadding;
  final double fontSize;
  final bool showEmoji;

  const CategoryChip({
    super.key,
    required this.category,
    this.labelPadding = const EdgeInsets.symmetric(horizontal: 5),
    this.fontSize = 11,
    this.showEmoji = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = _categoryColor(category);
    return Chip(
      labelPadding: labelPadding,
      label: Text(
        _formattedLabel(category, showEmoji),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: _textColorFor(bgColor),
        ),
      ),
      backgroundColor: bgColor,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -3),
    );
  }

  // ----------------- Helpers -----------------
  String _formattedLabel(String? text, bool withEmoji) {
    final capitalized = _capitalize(text);
    return withEmoji ? "${_categoryEmoji(text)} $capitalized" : capitalized;
  }

  String _capitalize(String? text) {
    if (text == null || text.isEmpty) return 'Unknown';
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  Color _textColorFor(Color background) =>
      background.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  Color _categoryColor(String? category) {
    switch (category?.trim().toLowerCase()) {
      case 'river':
        return Colors.cyan.shade100;
      case 'beach':
        return Colors.blue.shade100;
      case 'industrial':
        return Colors.grey.shade300;
      case 'mountain':
        return Colors.green.shade100;
      case 'historical':
        return Colors.brown.shade200;
      case 'cultural':
        return Colors.orange.shade100;
      case 'religious':
        return Colors.purple.shade100;
      case 'farm':
        return Colors.lime.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  String _categoryEmoji(String? category) {
    switch (category?.trim().toLowerCase()) {
      case 'river':
        return '🌊';
      case 'beach':
        return '🏖️';
      case 'industrial':
        return '🏭';
      case 'mountain':
        return '⛰️';
      case 'historical':
        return '🏛️';
      case 'cultural':
        return '🎭';
      case 'religious':
        return '🛕';
      case 'farm':
        return '🌾';
      default:
        return '📍';
    }
  }
}
