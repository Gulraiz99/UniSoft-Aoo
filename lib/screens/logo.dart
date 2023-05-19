import 'package:flutter/material.dart';
import 'login_screen.dart';

const double kDefaultPadding = 20.0;

class LogoScreen extends StatefulWidget {
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to LoginScreen after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.png',
              height: 300,
              width: 300,
            ),
            SizedBox(height: kDefaultPadding),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
