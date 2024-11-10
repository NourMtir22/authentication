import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'auth_service.dart';

class MainPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logOut(BuildContext context) async {
    await AuthService().logOut(); // Log out logic from the AuthService
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Main Page'),
        backgroundColor: Colors.grey[850],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logOut(context),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<User?>(
          future: _auth.currentUser != null ? Future.value(_auth.currentUser) : null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasData) {
              // Display user data
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome, ${snapshot.data?.email ?? 'User'}!',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to another page if needed
                    },
                    child: Text('Go to another page'),
                  ),
                ],
              );
            } else {
              return Text(
                'No user logged in',
                style: TextStyle(color: Colors.white, fontSize: 20),
              );
            }
          },
        ),
      ),
    );
  }
}
