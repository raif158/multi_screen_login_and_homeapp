import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/home_screen.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/profile_screen.dart';
import '../../feature/auth/presentation/screen/login_screen.dart';
import '../widget/custom_navBar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _currentIndex = 2;

  // ------------- Toggles --------------
  bool isDarkTheme = false;
  bool notificationsEnabled = true;

  void _onNavItemTapped(int index) {
    if (index == _currentIndex) return;

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------
            // Dark Mode Switch
            // -------------------------
            SwitchListTile(
              title: const Text("Dark Mode"),
              secondary: const Icon(Icons.dark_mode),
              value: isDarkTheme,
              onChanged: (value) {
                setState(() => isDarkTheme = value);

                // Mock action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value ? "Dark Mode ON" : "Dark Mode OFF"),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text("Enable Notifications"),
              secondary: const Icon(Icons.notifications),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() => notificationsEnabled = value);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? "Notifications Enabled"
                          : "Notifications Disabled",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Logged Out")));

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.red,
              ),
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 18, color: Colors.white),
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
