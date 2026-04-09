import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/quantity_selector.dart';
import '../../widgets/spicy_slider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 1;
  double _spicy = 0.3;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _addToCart() {
    for (int i = 0; i < _quantity; i++) {
      ref.read(cartProvider.notifier).addItem(widget.product);
    }
    // Navigate to payment screen instead of showing snackbar
    context.pushNamed('payment');
  }

  @override
  Widget build(BuildContext context) {
    final isCustomizable = widget.product.id == '5';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              if (isCustomizable) ...[
                _buildCustomizationView(),
              ] else ...[
                _buildStandardView(),
              ],
              _buildBottomAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final isFav = ref
        .watch(favoritesProvider.notifier)
        .isFavorite(widget.product.id);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? AppColors.heart : AppColors.textPrimary,
                ),
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggle(widget.product);
                },
              ),
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.textPrimary),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStandardView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Hero(
            tag: 'product-${widget.product.id}',
            child: Image.asset(
              widget.product.imageUrl,
              height: 280,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.star, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.product.rating} - ${widget.product.deliveryMinutes} mins',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.product.description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              _buildControls(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomizationView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Image.asset(
                  widget.product.imageUrl,
                  height: 320, // Aumentado para la hamburguesa "explotada"
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Customize ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const TextSpan(
                              text:
                                  'Your Burger\nto Your Tastes. Ultimate\nExperience'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SpicySlider(
                      value: _spicy,
                      onChanged: (val) => setState(() => _spicy = val),
                    ),
                    const SizedBox(height: 30),
                    QuantitySelector(
                      quantity: _quantity,
                      onIncrement: () => setState(() => _quantity++),
                      onDecrement: () => setState(() {
                        if (_quantity > 1) _quantity--;
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        _buildSelectionSection('Toppings', [
          _SelectionItem('Tomato', Icons.circle, Colors.red),
          _SelectionItem('Onions', Icons.circle, Colors.purple),
          _SelectionItem('Pickles', Icons.circle, Colors.green),
          _SelectionItem('Bacons', Icons.circle, Colors.brown),
        ]),
        const SizedBox(height: 20),
        _buildSelectionSection('Side options', [
          _SelectionItem('Fries', Icons.fastfood, Colors.orange),
          _SelectionItem('Coleslaw', Icons.restaurant, Colors.amber),
          _SelectionItem('Salad', Icons.eco, Colors.green),
          _SelectionItem('Onion', Icons.circle, Colors.purple),
        ]),
      ],
    );
  }

  Widget _buildSelectionSection(String title, List<_SelectionItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 85,
                margin: const EdgeInsets.only(right: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Icon(item.icon, color: item.color, size: 35),
                      ),
                    ),
                    Container(
                      height: 35,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3C2F2F), // Marrón oscuro del diseño
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(15)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.label,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SpicySlider(
            value: _spicy,
            onChanged: (val) => setState(() => _spicy = val),
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 1,
          child: QuantitySelector(
            quantity: _quantity,
            onIncrement: () => setState(() => _quantity++),
            onDecrement: () => setState(() {
              if (_quantity > 1) _quantity--;
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    (widget.product.price * _quantity).toStringAsFixed(2),
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: _addToCart,
            child: Container(
              height: 60,
              width: 180,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'ORDER NOW',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionItem {
  final String label;
  final IconData icon;
  final Color color;

  _SelectionItem(this.label, this.icon, this.color);
}
