import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A skeleton list‑tile that matches the real search result tile.
class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors
    final base = Colors.grey.shade300;
    final highlight = Colors.grey.shade100;

    return ListTile(
      leading: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
        ),
      ),
      title: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          height: 14,
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: Colors.white,
        ),
      ),
      subtitle: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          height: 12,
          width: 160,
          color: Colors.white,
        ),
      ),
    );
  }
}
