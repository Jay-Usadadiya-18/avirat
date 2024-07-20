import 'dart:async';

import 'package:avirat_energy/Auth/login_screen.dart';
import 'package:avirat_energy/get_customer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _startSplashScreenTimer();
    _setOpacityLevel();
  }

  void _startSplashScreenTimer() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLogin = sp.getBool('isLogin') ?? false;

    Timer(const Duration(seconds: 3), () {
      if (isLogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomerMaster1()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  void _setOpacityLevel() {
    Future.delayed(Duration.zero, () {
      setState(() {
        opacityLevel = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 1000),
          opacity: opacityLevel,
          child: Image.asset(
            'assets/images/avirat_energy.png',
            width: screenSize.width * 0.8,
            height: screenSize.width * 0.8,
          ),
        ),
      ),
    );
  }
}
