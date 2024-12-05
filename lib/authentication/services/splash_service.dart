import 'dart:async';
import 'package:edmyn/authentication/screens/login.dart';
import 'package:edmyn/dashboard/screens/dashboard.dart';
import 'package:edmyn/firestore/services/firestore_service.dart';
import 'package:edmyn/user/models/user_profile_model.dart';
import 'package:edmyn/user/screens/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashServices {
  Future<void> isLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool isProfileCompleted = prefs.getBool('profileCompleted') ?? false;
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (!isProfileCompleted) {
        // Check profile completion in Firestore only if not set in SharedPreferences
        UserProfile? userProfile = await FirestoreService().getUserProfile(user.uid);
        if (userProfile != null && userProfile.profileCompleted == true) {
          // Set the local flag if profile is completed in Firestore
          await prefs.setBool('profileCompleted', true);
          isProfileCompleted = true;
        }
      }

      if (isProfileCompleted) {
        // Navigate to Dashboard if profile is complete
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        // If profile is incomplete, navigate to UserProfileScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserProfileScreen(hideDrawer: true)),
        );
      }
    } else {
      // If no user is signed in, navigate to Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    }
  }
}
