import 'package:flutter/material.dart';
import 'shimmer_loader.dart';

class ShimmerListLoader extends StatelessWidget {
  final int itemCount;
  final BorderRadius borderRadius;

  const ShimmerListLoader({
    super.key,
    this.itemCount = 6,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => SizedBox(
        height: 180,
        child: MunicipalityShimmer(borderRadius: borderRadius),
      ),
    );
  }
}
