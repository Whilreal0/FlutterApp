import 'package:flutter/material.dart';
import '../models/tourist_spot.dart';
import '../widgets/custom_carousel_slider.dart';

class SpotCarousel extends StatelessWidget {
  final List<TouristSpot> spots;

  const SpotCarousel({super.key, required this.spots});

  @override
  Widget build(BuildContext context) {
    return CustomCarouselSlider(
      height: 200,
      items: spots.map((spot) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                spot.photos.isNotEmpty
                    ? spot.photos[0]
                    : 'https://via.placeholder.com/400',
                fit: BoxFit.cover,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  spot.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
