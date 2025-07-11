import 'package:flutter/material.dart';

class CarouselIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  const CarouselIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: currentIndex == index ? 12 : 8,
            height: currentIndex == index ? 12 : 8,
            decoration: BoxDecoration(
              color: currentIndex == index ? Colors.white : Colors.grey,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}
