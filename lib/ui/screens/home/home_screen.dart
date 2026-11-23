import 'package:flutter/material.dart';
import '../../responsive/responsive_layout.dart';
import 'mobile_home.dart';
import 'desktop_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: MobileHome(),
      tablet: DesktopHome(),
      desktop: DesktopHome(),
    );
  }
}
