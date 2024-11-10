import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'sign_up_page.dart';
import 'login_page.dart';
import 'main_page.dart'; // Import your main page after login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
      ),
      initialRoute: '/splash', // Set initial route to SplashScreen
      routes: {
        '/splash': (context) => SplashScreen(), // SplashScreen as the initial screen
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/main': (context) => MainPage(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulating loading or checking Firebase connection
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login'); // After loading, go to login page
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show loading spinner while initializing
      ),
    );
  }
}
