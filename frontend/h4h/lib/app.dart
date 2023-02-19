import 'package:flutter/material.dart';
import 'package:h4h/pages/map_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Page',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MapPage(),
    );
  }
}
