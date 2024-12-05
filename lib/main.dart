import 'package:edmyn/authentication/screens/login.dart';
import 'package:edmyn/authentication/screens/splash_screen.dart';
import 'package:edmyn/dashboard/screens/dashboard.dart';
import 'package:edmyn/firebase_options.dart';
import 'package:edmyn/shared/internet_checker/connectivity_provider.dart';
import 'package:edmyn/theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:edmyn/shared/global.dart' as global;
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  runApp(
  MultiProvider(providers: [ ChangeNotifierProvider(create: (_) => ConnectivityProvider()),],
    child: MyApp(),)
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key,  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'edmyn App',
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: global.navigatorKey,
      home:
      //currentUser != null ? Dashboard() : LogIn(),
      SplashScreen(),
    );
  }
}
