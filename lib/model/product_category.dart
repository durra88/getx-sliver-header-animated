class ProductCategory {
  ProductCategory({required this.category, required this.products});
  final String category;
  final List<Product> products;
}

class Product {
  Product(
      {required this.name,
      required this.description,
      required this.price,
      required this.image});
  String name, description, image;
  String price;
}
