// profile_screen.dart
import 'package:flutter/material.dart';

import 'auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _gender;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var userData = await _auth.fetchUserData();
    setState(() {
      _fullNameController.text = userData?['fullName'] ?? '';
      _emailController.text = userData?['email'] ?? '';
      _gender = userData?['gender'] ?? 'Male';
      _profileImageUrl = userData?['profileImageUrl'];
    });
  }

  Future<void> _updateProfile() async {
    await _auth.updateUserData(
      _fullNameController.text,
      _gender!,
      _profileImageUrl,
    );
  }

  Future<void> _logOut() async {
    await _auth.logOut();
    Navigator.pushReplacementNamed(context, '/welcomeBack');
  }

  Future<void> _deleteAccount() async {
    bool confirm = await _showDeleteConfirmation();
    if (confirm) {
      await _auth.deleteAccount();
      Navigator.pushReplacementNamed(context, '/welcomeBack');
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Account"),
        content: Text("Are you sure you want to delete your account?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("No")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Yes")),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_profileImageUrl != null)
              CircleAvatar(
                backgroundImage: NetworkImage(_profileImageUrl!),
                radius: 50,
              ),
            TextField(controller: _fullNameController, decoration: InputDecoration(labelText: 'Full Name')),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            DropdownButtonFormField(
              value: _gender,
              items: ['Male', 'Female', 'Other'].map((String gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _gender = value as String?;
                });
              },
              decoration: InputDecoration(labelText: "Gender"),
            ),
            ElevatedButton(onPressed: _updateProfile, child: Text('Update Profile')),
            ElevatedButton(onPressed: _deleteAccount, child: Text('Delete Account')),
            ElevatedButton(onPressed: _logOut, child: Text('Log Out')),
          ],
        ),
      ),
    );
  }
}
