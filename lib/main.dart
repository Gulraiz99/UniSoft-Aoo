import 'package:flutter/material.dart';
import 'package:unisoft_app/screens/home_scree.dart';
import 'package:unisoft_app/screens/login_screen.dart';
import 'screens/logo.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/userscatergory_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCnChJzfjmtqOOO7P3r43ysNPQC3ReA_ac",
      authDomain: "unisofty-a6a1c.firebaseapp.com",
      projectId: "unisofty-a6a1c",
      databaseURL:
          "https://unisofty-a6a1c-default-rtdb.firebaseio.com", // Add your Firebase URL here
      storageBucket: "gs://unisofty-a6a1c.appspot.com",
      messagingSenderId: "544883126664",
      appId: "1:544883126664:android:d88ddcbfc6794f7415ca3d",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniSoft',
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginScreen(),
        '/user-category': (context) => UserCategoryScreen(),
        '/home': (context) => HomeScreen()
      },
      theme: myTheme,
      home: LogoScreen(),
    );
  }
}

final ThemeData myTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFFAA96DA), // Updated to #aa96da
  hintColor: Color(0xFFAA96DA), // Updated to #aa96da
  fontFamily: 'Montserrat',
  textTheme: TextTheme(
    headline1: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyText1: TextStyle(
      fontSize: 16.0,
      color: Colors.white,
    ),
    button: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFFAA96DA), // Updated to #aa96da
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: AppBarTheme(
    color: Color(0xFFAA96DA), // Updated to #aa96da
    iconTheme: IconThemeData(color: Colors.white),
    toolbarTextStyle: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[900],
  cardColor: Colors.grey[800],
  dividerColor: Colors.grey[600],
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Color(0xFFAA96DA), // Updated to #aa96da
      onPrimary: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
    size: 24.0,
  ),
);
