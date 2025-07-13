import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MunicipalityShimmer extends StatelessWidget {
  final BorderRadius borderRadius;

  const MunicipalityShimmer({super.key, this.borderRadius = BorderRadius.zero});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}
