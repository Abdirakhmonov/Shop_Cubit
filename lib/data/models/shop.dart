class Shop {
  String id;
  String title;
  String image;
  String price;
  bool isFavorite;

  Shop({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.isFavorite = false,
  });
}
