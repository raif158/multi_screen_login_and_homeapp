import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multi_screen_login_and_homeapp/home/model/cart_model.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/cart_screen.dart';
import 'package:multi_screen_login_and_homeapp/home/presentation/wishlist_screen.dart';
import 'package:multi_screen_login_and_homeapp/home/repository/cart_repo.dart';
import '../widget/custom_category_nav.dart';
import '../widget/custom_navBar.dart';
import '../widget/custom_product_card.dart';
import '../model/product_model.dart';
import '../repository/product_repo.dart';
import '../../feature/auth/presentation/screen/login_screen.dart';
import 'profile_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  int _currentIndex = 0;
  final List<String> _categoryList = ['mens', 'women', 'makeup'];
  final ProductRepository _repo = ProductRepository();

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
    if (index == 1) _navigateToProfile(context);
    if (index == 2) _navigateToSettings(context);
    if (index == 3) _navigateToWish(context);
    if (index == 4) _navigateToCart(context);
  }

  Future<void> _navigateToProfile(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  Future<void> _navigateToSettings(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  Future<void> _navigateToWish(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const WishListScreen()));
  }

  Future<void> _navigateToCart(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CartPage()));
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
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: CategoryNav(
              category: _categoryList,
              selectedIndex: _selectedCategory,
              onTapIndex: (index) {
                setState(() {
                  _selectedCategory = index;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              // Use this for testing with hardcoded data first:
              // stream: _repo.getTestProducts(),
              stream: _repo.getAllProducts(),
              builder: (context, snapshot) {
                // DEBUG: Add comprehensive logging
                print('=== STREAM BUILDER STATE ===');
                print('Connection state: ${snapshot.connectionState}');
                print('Has data: ${snapshot.hasData}');
                print('Has error: ${snapshot.hasError}');

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print('Stream error: ${snapshot.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading products',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print('No data or empty data received');
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No Products Available',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final allProducts = snapshot.data!;
                print('Total products received: ${allProducts.length}');

                // Print all products for debugging
                for (var product in allProducts) {
                  print(
                    'Product: ${product.title}, Category: ${product.category}, ID: ${product.id}',
                  );
                }

                final filteredProducts = allProducts
                    .where(
                      (p) =>
                          p.category.toLowerCase() ==
                          _categoryList[_selectedCategory].toLowerCase(),
                    )
                    .toList();

                print(
                  'Filtered products for category "${_categoryList[_selectedCategory]}": ${filteredProducts.length}',
                );

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.category,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products in ${_categoryList[_selectedCategory]} category',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Selected ${product.title}')),
                        );
                      },
                      onAddToCart: () {
                        CartRepository().addProductToCart(
                          CartModel(
                            id: product.id,
                            title: product.title,
                            image: product.imagePath,
                            price: product.price,
                            qty: 1,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${product.title} to cart!'),
                          ),
                        );
                      },
                      onToggleFavorite: () {
                        setState(() {});
                      },
                    );
                  },
                );
              },
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
