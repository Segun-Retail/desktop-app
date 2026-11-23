import 'package:flutter/material.dart';

class TabletHome extends StatelessWidget {
  const TabletHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tablet")),
      body: const Center(
        child: Text("Tablet Layout"),
      ),
    );
  }
}