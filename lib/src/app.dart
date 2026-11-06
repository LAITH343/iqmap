import 'package:flutter/material.dart';
import 'package:iqmap/src/home/presentation/home_view.dart';

class App extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView());
  }
}
