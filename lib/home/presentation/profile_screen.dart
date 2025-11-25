import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/home_screen.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/setting_screen.dart';
import 'package:multi_screen_login_and_homeapp/home/widget/custom_text_feild.dart';

import '../widget/custom_navBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  int _currentIndex = 1;

  void _onNavItemTapped(int index) {
    if (index == _currentIndex) return; // Already on this screen

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      );
    }
  }

  String _getUserDisplayName(User? user) {
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user.displayName!;
    } else if (user?.email != null) {
      return user!.email!.split('@')[0];
    } else {
      return 'User';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _fullName = TextEditingController();
    final _phoneNumber = TextEditingController();
    final _gender = TextEditingController();
    final _addressLine1 = TextEditingController();
    final _city = TextEditingController();
    final _postalCode = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    final User? user = FirebaseAuth.instance.currentUser;
    final String displayName = _getUserDisplayName(user);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $displayName!',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(label: 'Full Name', controller: _fullName),
                  CustomTextField(
                    label: 'Phone Number,',
                    controller: _phoneNumber,
                  ),
                  CustomTextField(label: 'Gender', controller: _gender),
                  CustomTextField(label: 'City', controller: _city),
                  CustomTextField(label: 'Address', controller: _addressLine1),
                  CustomTextField(
                    label: 'Postal Code',
                    controller: _postalCode,
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(horizontal: 40),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
        isHomeActive: false,
      ),
    );
  }
}
