import 'package:flutter/material.dart';
import '../model/product_model.dart';
import '../repository/product_repo.dart';
import '../widget/custom_product_card.dart';
import '../widget/custom_navBar.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/profile_screen.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/setting_screen.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/home_screen.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  final ProductRepository _repo = ProductRepository();
  int _currentIndex = 3;

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) _navigateToHome(context);
    if (index == 1) _navigateToProfile(context);
    if (index == 2) _navigateToSettings(context);
    if (index == 4) _navigateToCart(context);
  }

  Future<void> _navigateToHome(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  Future<void> _navigateToProfile(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  Future<void> _navigateToSettings(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  Future<void> _navigateToCart(BuildContext context) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cart screen coming soon!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wish List'), centerTitle: true),
      body: StreamBuilder<List<Product>>(
        stream: _repo.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          final wishListProducts = snapshot.data!
              .where((product) => product.isFavorite)
              .toList();

          if (wishListProducts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No products in Wish List',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: wishListProducts.length,
            itemBuilder: (context, index) {
              final product = wishListProducts[index];
              return ProductCard(
                product: product,
                onToggleFavorite: () {
                  setState(() {});
                },
                onAddToCart: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.title} added to cart!')),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
        isHomeActive: false,
      ),
    );
  }
}
