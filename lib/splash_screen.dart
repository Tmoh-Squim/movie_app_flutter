import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/components/app/screens/home_screen.dart';
import 'package:movie_app/components/app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoggedInState();
  }

  _checkLoggedInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset('assets/animation/Splash.json'),
      ),
      duration: 3500,
      backgroundColor: Color(0xFF28303D),
      splashIconSize: 300,
      nextScreen: _getNextScreen(),
    );
  }

  Widget _getNextScreen() {
    return _isLoggedIn ? HomeScreen() : SplashScreen();
  }
}
