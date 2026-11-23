import 'package:flutter/material.dart';

class MobileHome extends StatelessWidget {
  const MobileHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mobile")),
      body: const Center(
        child: Text("Mobile Layout"),
      ),
    );
  }
}