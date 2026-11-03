import 'package:flutter/material.dart';

const _ink = Color(0xFF20231F);
const _muted = Color(0xFF777B73);
const _paper = Color(0xFFF7F7F2);
const _tomato = Color(0xFFE9523D);
const _line = Color(0xFFE8E8E1);

class FoodbusengApp extends StatelessWidget {
  const FoodbusengApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodbuseng',
      theme: ThemeData(
        scaffoldBackgroundColor: _paper,
        colorScheme: ColorScheme.fromSeed(seedColor: _tomato, primary: _tomato),
        useMaterial3: true,
      ),
      home: const FoodbusengHome(),
    );
  }
}

class FoodbusengHome extends StatefulWidget {
  const FoodbusengHome({super.key});

  @override
  State<FoodbusengHome> createState() => _FoodbusengHomeState();
}

class _FoodbusengHomeState extends State<FoodbusengHome> {
  final _search = TextEditingController();
  final Map<String, int> _cart = {};
  String _category = 'All';
  bool _showCart = false;

  int get _count => _cart.values.fold(0, (sum, quantity) => sum + quantity);
  double get _subtotal => _menu.fold<double>(
    0,
    (sum, item) => sum + item.price * (_cart[item.id] ?? 0),
  );

  List<FoodItem> get _filteredMenu {
    final query = _search.text.trim().toLowerCase();
    return _menu.where((item) {
      return (_category == 'All' || item.category == _category) &&
          (query.isEmpty || item.name.toLowerCase().contains(query));
    }).toList();
  }

  void _updateCart(FoodItem item, int delta) {
    setState(() {
      final next = (_cart[item.id] ?? 0) + delta;
      if (next <= 0) {
        _cart.remove(item.id);
      } else {
        _cart[item.id] = next;
      }
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 900) {
                    return Row(
                      children: [
                        Expanded(child: _menuPane()),
                        Container(width: 1, color: _line),
                        SizedBox(width: 365, child: _cartPane()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Expanded(child: _showCart ? _cartPane() : _menuPane()),
                      if (!_showCart) _mobileCartBar(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    final compact = MediaQuery.sizeOf(context).width < 520;
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: compact ? 17 : 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _tomato,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fastfood_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'foodbuseng',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: _ink,
            ),
          ),
          const Spacer(),
          if (!compact) ...[
            const Icon(Icons.location_on_outlined, size: 19, color: _tomato),
            const SizedBox(width: 5),
            const Text(
              'Deliver to',
              style: TextStyle(color: _muted, fontSize: 12),
            ),
            const SizedBox(width: 4),
            const Text(
              'Brooklyn, NY',
              style: TextStyle(
                color: _ink,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 18),
          ],
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE6B8),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('J', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuPane() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 500 ? 18.0 : 32.0;
        final columns = constraints.maxWidth > 680 ? 3 : 2;
        return ListView(
          padding: EdgeInsets.fromLTRB(padding, 24, padding, 26),
          children: [
            _hero(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'What sounds good?',
                    style: TextStyle(
                      fontSize: constraints.maxWidth < 500 ? 20 : 24,
                      fontWeight: FontWeight.w900,
                      color: _ink,
                    ),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth < 500 ? 118 : 195,
                  height: 40,
                  child: TextField(
                    controller: _search,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search menu',
                      hintStyle: const TextStyle(fontSize: 12, color: _muted),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 19,
                        color: _muted,
                      ),
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _line),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _line),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final category in _categories)
                    Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _category == category,
                        onSelected: (_) => setState(() => _category = category),
                        showCheckmark: false,
                        selectedColor: _ink,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: _category == category ? _ink : _line,
                        ),
                        labelStyle: TextStyle(
                          color: _category == category ? Colors.white : _ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 17),
            if (_filteredMenu.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text('No dishes found. Try another search.'),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredMenu.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 15,
                  mainAxisExtent: 251,
                ),
                itemBuilder: (context, index) =>
                    _productCard(_filteredMenu[index]),
              ),
          ],
        );
      },
    );
  }

  Widget _hero() {
    return Container(
      height: 166,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE3B2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -14,
            top: -18,
            bottom: -18,
            width: 230,
            child: Image.network(
              _menu.first.image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFFFFD18B),
                child: Center(
                  child: Text('🍔', style: TextStyle(fontSize: 72)),
                ),
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFE3B2), Color(0x14FFE3B2)],
                stops: [0.43, 1],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(21, 17, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'THE GOOD STUFF',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  'Big flavor.\nZero fuss.',
                  style: TextStyle(
                    fontSize: 27,
                    height: 1.03,
                    fontWeight: FontWeight.w900,
                    color: _ink,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Made fresh, delivered happy.',
                  style: TextStyle(fontSize: 11, color: _ink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCard(FoodItem item) {
    final quantity = _cart[item.id] ?? 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 129,
                width: double.infinity,
                child: Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => ColoredBox(
                    color: item.tint,
                    child: Center(
                      child: Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                ),
              ),
              if (item.badge != null)
                Positioned(
                  top: 9,
                  left: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 8, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _ink,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFF3B33D),
                      ),
                      Text(
                        item.rating,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: _muted),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                        ),
                      ),
                      const Spacer(),
                      if (quantity > 0)
                        SizedBox(
                          width: 22,
                          child: Center(
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      _quantityButton(
                        Icons.add,
                        'Add ${item.name}',
                        () => _updateCart(item, 1),
                        filled: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(
    IconData icon,
    String label,
    VoidCallback onPressed, {
    bool filled = false,
  }) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: filled ? _tomato : const Color(0xFFF2F2ED),
          foregroundColor: filled ? Colors.white : _ink,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        icon: Icon(icon, size: 16),
      ),
    );
  }

  Widget _cartPane() {
    final items = _menu.where((item) => (_cart[item.id] ?? 0) > 0).toList();
    final delivery = _subtotal == 0 ? 0.0 : 2.50;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(22, 23, 22, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (_showCart)
                IconButton(
                  tooltip: 'Back to menu',
                  onPressed: () => setState(() => _showCart = false),
                  icon: const Icon(Icons.arrow_back),
                ),
              const Expanded(
                child: Text(
                  'Your order',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: _ink,
                  ),
                ),
              ),
              if (_count > 0)
                Text(
                  '$_count items',
                  style: const TextStyle(
                    fontSize: 12,
                    color: _muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'From Foodbuseng Kitchen',
            style: TextStyle(fontSize: 12, color: _muted),
          ),
          const SizedBox(height: 17),
          const Divider(height: 1, color: _line),
          if (items.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF1D9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 28,
                        color: _tomato,
                      ),
                    ),
                    const SizedBox(height: 13),
                    const Text(
                      'Your bag is taking a nap',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Add something delicious to wake it up.',
                      style: TextStyle(fontSize: 11, color: _muted),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 7),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: _line),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final quantity = _cart[item.id]!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Image.network(
                              item.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => ColoredBox(
                                color: item.tint,
                                child: Center(
                                  child: Text(
                                    item.emoji,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: _ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: _muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _quantityButton(
                          Icons.remove,
                          'Remove one ${item.name}',
                          () => _updateCart(item, -1),
                        ),
                        SizedBox(
                          width: 22,
                          child: Center(
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        _quantityButton(
                          Icons.add,
                          'Add ${item.name}',
                          () => _updateCart(item, 1),
                          filled: true,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          const Divider(height: 1, color: _line),
          const SizedBox(height: 13),
          _priceRow('Subtotal', _subtotal),
          const SizedBox(height: 8),
          _priceRow('Delivery', delivery),
          const SizedBox(height: 12),
          _priceRow('Total', _subtotal + delivery, bold: true),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 47,
            child: FilledButton(
              onPressed: _count == 0
                  ? null
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Order received! We are getting it ready.',
                        ),
                      ),
                    ),
              style: FilledButton.styleFrom(
                backgroundColor: _tomato,
                disabledBackgroundColor: const Color(0xFFE5E5DF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: Text(
                _count == 0
                    ? 'Add items to continue'
                    : 'Checkout  ·  \$${(_subtotal + delivery).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double amount, {bool bold = false}) {
    final style = TextStyle(
      fontSize: bold ? 15 : 12,
      color: _ink,
      fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
    );
    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text('\$${amount.toStringAsFixed(2)}', style: style),
      ],
    );
  }

  Widget _mobileCartBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 11, 18, 13),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _line)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 49,
        child: FilledButton(
          onPressed: () => setState(() => _showCart = true),
          style: FilledButton.styleFrom(
            backgroundColor: _ink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .17),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$_count',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'View order',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              Text(
                '\$${_subtotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 7),
              const Icon(Icons.arrow_forward, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.image,
    required this.emoji,
    required this.tint,
    this.badge,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String rating;
  final String image;
  final String emoji;
  final Color tint;
  final String? badge;
}

const _categories = ['All', 'Burgers', 'Pizza', 'Sides', 'Drinks'];

const _menu = [
  FoodItem(
    id: 'smash',
    name: 'Double smash burger',
    description: 'Two patties, cheddar, house sauce',
    category: 'Burgers',
    price: 12.50,
    rating: '4.9',
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=700&q=80',
    emoji: '🍔',
    tint: Color(0xFFFFE5B9),
    badge: 'BEST SELLER',
  ),
  FoodItem(
    id: 'crispy',
    name: 'Crispy chicken bun',
    description: 'Buttermilk chicken, slaw, pickles',
    category: 'Burgers',
    price: 11,
    rating: '4.8',
    image: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?auto=format&fit=crop&w=700&q=80',
    emoji: '🍗',
    tint: Color(0xFFFFEACF),
  ),
  FoodItem(
    id: 'margherita',
    name: 'Garden margherita',
    description: 'Tomato, basil, fresh mozzarella',
    category: 'Pizza',
    price: 14,
    rating: '4.7',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?auto=format&fit=crop&w=700&q=80',
    emoji: '🍕',
    tint: Color(0xFFFFE4C1),
    badge: 'VEGETARIAN',
  ),
  FoodItem(
    id: 'fries',
    name: 'Golden shoestrings',
    description: 'Rosemary salt, garlic aioli',
    category: 'Sides',
    price: 5.50,
    rating: '4.9',
    image: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=700&q=80',
    emoji: '🍟',
    tint: Color(0xFFFFF0C1),
  ),
  FoodItem(
    id: 'salad',
    name: 'Chopped green salad',
    description: 'Avocado, herbs, lemon dressing',
    category: 'Sides',
    price: 8,
    rating: '4.6',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=700&q=80',
    emoji: '🥗',
    tint: Color(0xFFDCEBCF),
  ),
  FoodItem(
    id: 'lemonade',
    name: 'Fresh squeezed lemonade',
    description: 'Real lemons, a little sunshine',
    category: 'Drinks',
    price: 4,
    rating: '4.8',
    image: 'https://images.unsplash.com/photo-1513558161293-cdaf765edfd7?auto=format&fit=crop&w=700&q=80',
    emoji: '🍋',
    tint: Color(0xFFFFF0B7),
  ),
];
