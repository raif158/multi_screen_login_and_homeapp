class CartModel {
  final String id;
  final String title;
  final double price;
  final String image;
  final int qty;
  CartModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.qty,
  });
  factory CartModel.fromMap(Map<String, dynamic> data) {
    return CartModel(
      id: data['id'],
      title: data['title'],
      image: data['image'],
      price: data['price'],
      qty: data['qty'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'price': price,
      'qty': qty,
    };
  }
}
