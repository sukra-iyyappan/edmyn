import 'dart:async';
import 'package:flutter/material.dart';
import 'package:edmyn/authentication/services/splash_service.dart';

import '../../shared/constants/image_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices splashScreen = SplashServices();
  bool _isVisible = false; // Control the visibility for fade-in effect
  Timer? _fadeTimer;
  Timer? _navigateTimer;

  @override
  void initState() {
    super.initState();


    // Start the fade-in animation
    _fadeTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) { // Check if the widget is still mounted
        setState(() {
          _isVisible = true; // Show the logo after 1 second
        });
      }
    });


    _navigateTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        splashScreen.isLogin(context);
      }
    });
  }

  @override
  void dispose() {
    _fadeTimer?.cancel(); // Cancel the fade-in timer if disposed
    _navigateTimer?.cancel(); // Cancel the navigation timer if disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0, // Control opacity
          duration: const Duration(seconds: 4), // Animation duration
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // The logo animation
              Image(image: AssetImage(ImagePaths.logo),height: 40,),
              const SizedBox(height: 20),
              // const Text(
              //   'Welcome to edmyn App',
              //   style: TextStyle(fontSize: 25),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
