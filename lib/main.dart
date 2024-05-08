import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/components/app/screens/category_screen.dart';
import 'package:movie_app/components/app/screens/home_screen.dart';
import 'package:movie_app/components/auth/login.dart';
import 'package:movie_app/components/auth/register.dart';
import 'package:movie_app/components/movie/create_movie.dart';
import 'package:movie_app/firebase_options.dart';
import 'package:movie_app/routes/routes.dart';
import 'package:movie_app/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieDS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => SplashScreen1(),
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.register: (context) => Register(),
        AppRoutes.login: (context) => Login(),
        AppRoutes.category: (context) => CategoryScreen(),
        AppRoutes.createMovie: (context) => UploadDataScreen(),
      },
    );
  }
}

// ...