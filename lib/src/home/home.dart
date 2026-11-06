import 'package:flutter/material.dart';
import 'package:iqmap/src/home/widgets/map_widget.dart';
import 'package:iqmap/src/home/widgets/search_for_locations.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: MapWidget()),
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: SafeArea(child: SearchForLocations()),
          ),
        ],
      ),
    );
  }
}
