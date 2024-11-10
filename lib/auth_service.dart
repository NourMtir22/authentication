// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp(String email, String password, String fullName, String gender) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'gender': gender,
      });
    } catch (e) {
      print('Sign-up failed: $e');
      rethrow; // or handle error as needed
    }
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
        return userData.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
    return null;
  }

  Future<void> updateUserData(String fullName, String gender, String? profileImageUrl) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fullName': fullName,
          'gender': gender,
          'profileImageUrl': profileImageUrl,
        });
      }
    } catch (e) {
      print('Failed to update user data: $e');
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Logout failed: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
      }
    } catch (e) {
      print('Account deletion failed: $e');
    }
  }
}