import 'package:flutter/material.dart';
import 'package:h4h/pages/openstreetmap_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder:
                      (context) => /*Add page here, ex: const MapPage()*/ const MapSample())),
              child: const Text('Leo\'s map'))
        ],
      ),
    );
  }
}
