import '../models/product.dart';

final List<Product> sampleProducts = [
  Product(
    id: '1',
    name: "Cheeseburger Wendy's Burger",
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles.",
    price: 8.24,
    rating: 4.9,
    deliveryMinutes: 26,
    imageUrl: 'assets/images/cheeseburger.png',
    category: 'Combos',
  ),
  Product(
    id: '2',
    name: 'Hamburger Veggie Burger',
    description:
        'Enjoy our delicious Hamburger Veggie Burger, made with a savory blend of fresh vegetables and herbs, topped with crisp lettuce, juicy tomatoes, and tangy pickles, all served on a soft, toasted bun.',
    price: 9.99,
    rating: 4.8,
    deliveryMinutes: 14,
    imageUrl: 'assets/images/veggie_burger.png',
    category: 'Sliders',
  ),
  Product(
    id: '3',
    name: 'Hamburger Chicken Burger',
    description:
        'Our chicken burger is a delicious and healthier alternative to traditional beef burgers, perfect for those looking for a lighter meal option. Try it today and experience the mouth-watering flavors of our Hamburger Chicken Burger!',
    price: 12.48,
    rating: 4.6,
    deliveryMinutes: 42,
    imageUrl: 'assets/images/chicken_burger.png',
    category: 'Combos',
  ),
  Product(
    id: '4',
    name: 'Fried Chicken Burger',
    description:
        'Indulge in our crispy and savory Fried Chicken Burger, made with a juicy chicken patty, hand-breaded and deep-fried to perfection, served on a warm bun with lettuce, tomato, and a creamy sauce.',
    price: 26.99,
    rating: 4.5,
    deliveryMinutes: 14,
    imageUrl: 'assets/images/fried_chicken_burger.png',
    category: 'Classic',
  ),
];
