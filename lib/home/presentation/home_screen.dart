import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/profile_screen.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/setting_screen.dart';
import '../../feature/auth/presentation/screen/login_screen.dart';
import '../widget/custom_navBar.dart';
import '../widget/custom_product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Logout error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
      }
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      _navigateToProfile(context);
    } else if (index == 2) {
      _navigateToSettings(context);
    }
  }

  Future<void> _navigateToProfile(BuildContext context) async {
    try {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
    } catch (e) {
      debugPrint('Profile navigation error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open Profile: $e')));
      }
    }
  }

  Future<void> _navigateToSettings(BuildContext context) async {
    try {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
    } catch (e) {
      debugPrint('Settings navigation error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open Settings: $e')));
      }
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
    final User? user = FirebaseAuth.instance.currentUser;
    final String displayName = _getUserDisplayName(user);
    final String email = user?.email ?? 'No Email';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $displayName!',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  email,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(8.0),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ProductCard(
                    title: "Product $index",
                    description:
                        "This is a sample description for product $index",
                    price: "\$${(index + 1) * 10}",
                    oldPrice: "\$${(index + 1) * 15}",
                    discount: "10% OFF",
                    imagePath: "assets/images/gt.png",
                    rating: 4.0,
                    ratingCount: 20,
                  );
                },
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
        isHomeActive: true,
      ),
    );
  }
}
