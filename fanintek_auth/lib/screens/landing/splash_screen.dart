import 'dart:async';
import 'package:fanintek_auth/screens/auth/login_screen.dart';
import 'package:fanintek_auth/screens/home/home_screen.dart';
import 'package:fanintek_auth/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _startSplashScreen() async {
    User? user = FirebaseAuth.instance.currentUser;
    Duration duration = const Duration(seconds: 3);
    bool isLogin = false;
    if (user != null) {
      isLogin = true;
    } else {
      isLogin = false;
    }

    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            if (isLogin) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSplashScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/logo.png"),
                    width: 150,
                    height: 150,
                    color: primaryColor500,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Fanintek Auth',
                    style: titleTextStyle.copyWith(color: primaryColor500),
                  ),
                  Text(
                    'example authentication app with firebase',
                    style: subtitleTextStyle.copyWith(color: primaryColor500, fontSize: 12.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
