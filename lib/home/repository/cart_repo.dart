import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multi_screen_login_and_homeapp/home/model/cart_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get userId => _auth.currentUser!.uid;
  Future<void> addProductToCart(CartModel cartItem) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(cartItem.id)
        .set(cartItem.toMap(), SetOptions(merge: true));
  }

  Stream<List<CartModel>> getCartItems() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map(
          (snapShot) => snapShot.docs
              .map((doc) => CartModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> getUpdateQty(String id, int newQty) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(id)
        .update({"qty": newQty});
  }

  Future<void> removeItem(String id) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(id)
        .delete();
  }
}
