import 'package:flutter/material.dart';
import 'package:iqmap/src/home/widgets/map_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MapWidget());
  }
}
