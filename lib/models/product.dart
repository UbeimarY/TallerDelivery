class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int deliveryMinutes;
  final String imageUrl;
  final String category;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.deliveryMinutes,
    required this.imageUrl,
    required this.category,
    this.isFavorite = false,
  });
}
