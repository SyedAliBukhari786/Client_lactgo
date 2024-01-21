import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:lactgo_user/login.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Call the function to navigate after 3 seconds
    Timer(Duration(seconds: 3), () {
      // Replace 'LoginPage()' with the actual class or widget you want to navigate to
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor:Color(0xFF232F3E),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hi, Seller",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: screenWidth * 0.1,
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                Text(
                  "Welcome To Lactgo",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: screenWidth * 0.08,
                  ),
                ),
                Text(
                  "Selling Platform",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: screenWidth * 0.08,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Add your LoginPage implementation here
