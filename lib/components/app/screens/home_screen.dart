import 'package:flutter/material.dart';
import 'package:movie_app/components/app/screens/mobile_layout.dart';
import 'package:movie_app/components/app/screens/web_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 935) {
        return MobileLayout();
      }
      return WebLayout();
    });
  }
}
