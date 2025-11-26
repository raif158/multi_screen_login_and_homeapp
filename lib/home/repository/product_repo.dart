import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _products => _firestore.collection('products');

  Future<void> createProduct(Product product) async {
    await _products.doc(product.id).set(product.toMap());
  }

  Stream<List<Product>> getAllProducts() {
    return _products
        .snapshots()
        .map((snapshot) {
          print(
            'Firestore snapshot received: ${snapshot.docs.length} documents',
          );

          final products = snapshot.docs.map((doc) {
            try {
              print('Document ID: ${doc.id}');
              print('Document data: ${doc.data()}');

              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              final product = Product.fromMap(data);
              return product;
            } catch (e) {
              print('Error parsing document ${doc.id}: $e');
              print('Problematic document data: ${doc.data()}');
              return Product(
                id: doc.id,
                title: 'Error Loading Product',
                description: 'There was an error loading this product',
                price: 0.0,
                oldPrice: 0.0,
                discount: '',
                imagePath: 'https://via.placeholder.com/200',
                rating: 0.0,
                ratingCount: 0,
                isTrending: false,
                category: 'unknown',
                brand: 'Unknown',
                stock: 0,
                createdAt: DateTime.now(),
                isFavorite: false,
              );
            }
          }).toList();

          print('Successfully parsed ${products.length} products');
          return products;
        })
        .handleError((error) {
          print('Firestore stream error: $error');
          throw error;
        });
  }

  Future<Product?> getProductById(String id) async {
    try {
      final doc = await _products.doc(id).get();
      print('Getting product by ID: $id');
      print('Document exists: ${doc.exists}');

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error getting product by ID $id: $e');
      return null;
    }
  }

  Future<void> updateProduct(
    String id,
    Map<String, dynamic> updatedData,
  ) async {
    await _products.doc(id).update(updatedData);
  }

  Future<void> deleteProduct(String id) async {
    await _products.doc(id).delete();
  }

  Future<bool> isStockAvailable(String productId) async {
    final product = await getProductById(productId);
    if (product == null) return false;
    return product.stock > 0;
  }

  Future<void> toggleFavorite(String productId) async {
    final product = await getProductById(productId);
    if (product == null) return;

    final newStatus = !product.isFavorite;
    await updateProduct(productId, {'isFavorite': newStatus});
  }
}
