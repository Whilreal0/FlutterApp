import 'dart:async';
import 'package:flutter/material.dart';

class CustomCarouselSlider extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final double aspectRatio;
  final bool enlargeCenterPage;

  const CustomCarouselSlider({
    Key? key,
    required this.items,
    this.height = 200,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.aspectRatio = 16 / 9,
    this.enlargeCenterPage = true,
  }) : super(key: key);

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted) return;
      _currentIndex = (_currentIndex + 1) % widget.items.length;
      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height;
    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.items.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final isCenter = index == _currentIndex;
          final scale = widget.enlargeCenterPage ? (isCenter ? 1.0 : 0.9) : 1.0;
          return AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: widget.items[index],
            ),
          );
        },
      ),
    );
  }
}
