import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../../orders/presentation/widgets/order_cart_sidebar.dart';
import '../../../orders/presentation/providers/active_order_provider.dart';
import '../../../../core/theme/app_colors.dart';

// ── Mock Data ─────────────────────────────────────────────────────────────────
const _categories = [
  _Cat('All',       Icons.apps_rounded),
  _Cat('Pizza',     Icons.local_pizza_rounded),
  _Cat('Burgers',   Icons.lunch_dining_rounded),
  _Cat('Pasta',     Icons.ramen_dining_rounded),
  _Cat('Salads',    Icons.eco_rounded),
  _Cat('Drinks',    Icons.local_bar_rounded),
  _Cat('Desserts',  Icons.cake_rounded),
  _Cat('Snacks',    Icons.fastfood_rounded),
  _Cat('Extras',    Icons.add_circle_outline_rounded),
];

class _Cat {
  final String name;
  final IconData icon;
  const _Cat(this.name, this.icon);
}

final _mockItems = [
  const MenuItemEntity(id: 'm1', categoryId: 'Pizza',    name: 'Margherita Pizza',    description: 'Classic tomato & fresh mozzarella', price: 12.50),
  const MenuItemEntity(id: 'm2', categoryId: 'Pizza',    name: 'Pepperoni Pizza',     description: 'Loaded pepperoni, spicy kick',        price: 14.50),
  const MenuItemEntity(id: 'm3', categoryId: 'Burgers',  name: 'Cheese Burger',       description: 'Double patty, special sauce',          price: 10.25),
  const MenuItemEntity(id: 'm4', categoryId: 'Salads',   name: 'Caesar Salad',        description: 'Crispy romaine, parmesan, croutons',   price: 8.75),
  const MenuItemEntity(id: 'm5', categoryId: 'Drinks',   name: 'Mojito',              description: 'Fresh mint, lime & sparkling soda',    price: 5.75),
  const MenuItemEntity(id: 'm6', categoryId: 'Snacks',   name: 'French Fries',        description: 'Golden crispy seasoned fries',         price: 4.25),
  const MenuItemEntity(id: 'm7', categoryId: 'Pasta',    name: 'Spaghetti Bolognese', description: 'Rich meat ragù, al dente pasta',       price: 11.00),
  const MenuItemEntity(id: 'm8', categoryId: 'Burgers',  name: 'Chicken Wings',       description: '8 pcs, choice of buffalo sauce',       price: 9.25),
  const MenuItemEntity(id: 'm9', categoryId: 'Desserts', name: 'Chocolate Cake',      description: 'Warm dark chocolate lava cake',        price: 6.50),
  const MenuItemEntity(id: 'm10', categoryId: 'Drinks',  name: 'Lemonade',            description: 'Freshly squeezed with mint',           price: 4.00),
  const MenuItemEntity(id: 'm11', categoryId: 'Pizza',   name: 'BBQ Chicken Pizza',   description: 'Smoky BBQ base, grilled chicken',      price: 15.00),
  const MenuItemEntity(id: 'm12', categoryId: 'Pasta',   name: 'Penne Arrabiata',     description: 'Spicy tomato sauce, fresh basil',      price: 9.50),
];

// Card accent colors per category
const _catColors = {
  'Pizza':    Color(0xFFFF6B35),
  'Burgers':  Color(0xFFE63946),
  'Pasta':    Color(0xFFF4A261),
  'Salads':   Color(0xFF2A9D8F),
  'Drinks':   Color(0xFF4361EE),
  'Desserts': Color(0xFFE040FB),
  'Snacks':   Color(0xFFFFBE0B),
  'Extras':   Color(0xFF06D6A0),
};

Color _colorFor(String catId) => _catColors[catId] ?? AppColors.primary;

// Emoji-based food icons (no real images needed)
const _catEmoji = {
  'Pizza':    '🍕',
  'Burgers':  '🍔',
  'Pasta':    '🍝',
  'Salads':   '🥗',
  'Drinks':   '🍹',
  'Desserts': '🍰',
  'Snacks':   '🍟',
  'Extras':   '✨',
};

// ── Screen ────────────────────────────────────────────────────────────────────
class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  int _selectedTab = 0;
  String _search = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<MenuItemEntity> get _filteredItems {
    return _mockItems.where((item) {
      final matchCat = _selectedCategory == 'All' || item.categoryId == _selectedCategory;
      final matchSearch = _search.isEmpty ||
          item.name.toLowerCase().contains(_search.toLowerCase()) ||
          item.description.toLowerCase().contains(_search.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Row(
        children: [
          // ── Category rail ──────────────────────────────────────────────────
          _CategoryRail(
            selected: _selectedCategory,
            onSelect: (cat) => setState(() => _selectedCategory = cat),
          ),

          // ── Main menu area ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Top bar
                _MenuTopBar(
                  selectedTab: _selectedTab,
                  onTabChange: (t) => setState(() => _selectedTab = t),
                  onSearch: (q) => setState(() => _search = q),
                  itemCount: _filteredItems.length,
                  category: _selectedCategory,
                ),

                // Grid
                Expanded(
                  child: _filteredItems.isEmpty
                      ? _EmptySearch()
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return _PremiumMenuCard(
                              item: item,
                              accentColor: _colorFor(item.categoryId),
                              emoji: _catEmoji[item.categoryId] ?? '🍽️',
                              onTap: () => ref.read(activeOrderControllerProvider.notifier).addItem(item),
                            ).animate()
                              .fadeIn(delay: (index * 35).ms, duration: 280.ms)
                              .scale(begin: const Offset(0.92, 0.92), curve: Curves.easeOutBack);
                          },
                        ),
                ),
              ],
            ),
          ),

          // ── Cart sidebar ───────────────────────────────────────────────────
          const OrderCartSidebar(),
        ],
      ),
    );
  }
}

// ── Category Rail ─────────────────────────────────────────────────────────────
class _CategoryRail extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _CategoryRail({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFEEF0F4))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final isSelected = selected == cat.name;
                final color = isSelected ? AppColors.primary : const Color(0xFF94A3B8);
                return GestureDetector(
                  onTap: () => onSelect(cat.name),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 42, height: 42,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))] : null,
                          ),
                          child: Icon(cat.icon, color: isSelected ? Colors.white : color, size: 20),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? AppColors.primary : const Color(0xFF94A3B8),
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────
class _MenuTopBar extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChange;
  final ValueChanged<String> onSearch;
  final int itemCount;
  final String category;
  const _MenuTopBar({required this.selectedTab, required this.onTabChange, required this.onSearch, required this.itemCount, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEF0F4))),
      ),
      child: Row(
        children: [
          // Order type selector
          Container(
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(3),
            child: Row(
              children: [
                _TabChip(label: 'Dine In',   icon: Icons.restaurant_rounded,     selected: selectedTab == 0, onTap: () => onTabChange(0)),
                _TabChip(label: 'Takeaway',  icon: Icons.shopping_bag_outlined,   selected: selectedTab == 1, onTap: () => onTabChange(1)),
                _TabChip(label: 'Delivery',  icon: Icons.delivery_dining_rounded, selected: selectedTab == 2, onTap: () => onTabChange(2)),
              ],
            ),
          ),
          const Spacer(),
          // Item count badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.grid_view_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text('$itemCount items', style: const TextStyle(color: AppColors.primary, fontSize: 12.5, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Search
          Container(
            width: 220, height: 40,
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
            child: TextField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                hintText: 'Search menu...',
                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                prefixIcon: Icon(Icons.search_rounded, size: 18, color: Color(0xFF94A3B8)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TabChip({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected ? [const BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: selected ? AppColors.primary : const Color(0xFF94A3B8)),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(
              color: selected ? AppColors.primary : const Color(0xFF94A3B8),
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            )),
          ],
        ),
      ),
    );
  }
}

// ── Premium Menu Card ─────────────────────────────────────────────────────────
class _PremiumMenuCard extends StatefulWidget {
  final MenuItemEntity item;
  final Color accentColor;
  final String emoji;
  final VoidCallback onTap;
  const _PremiumMenuCard({required this.item, required this.accentColor, required this.emoji, required this.onTap});

  @override
  State<_PremiumMenuCard> createState() => _PremiumMenuCardState();
}

class _PremiumMenuCardState extends State<_PremiumMenuCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.accentColor;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _hovered ? c : const Color(0xFFEEF0F4), width: _hovered ? 1.5 : 1),
            boxShadow: _hovered
                ? [BoxShadow(color: c.withValues(alpha: 0.18), blurRadius: 20, offset: const Offset(0, 6))]
                : [const BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image / emoji area
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [c.withValues(alpha: _hovered ? 0.22 : 0.13), c.withValues(alpha: _hovered ? 0.08 : 0.04)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(top: -16, right: -16,
                        child: Container(width: 64, height: 64,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: c.withValues(alpha: 0.1)))),
                      Positioned(bottom: -8, left: -8,
                        child: Container(width: 40, height: 40,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: c.withValues(alpha: 0.08)))),
                      // Emoji
                      Center(
                        child: AnimatedScale(
                          scale: _hovered ? 1.12 : 1.0,
                          duration: const Duration(milliseconds: 180),
                          child: Text(widget.emoji, style: const TextStyle(fontSize: 52)),
                        ),
                      ),
                      // Add button
                      Positioned(
                        top: 10, right: 10,
                        child: AnimatedOpacity(
                          opacity: _hovered ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 160),
                          child: Container(
                            width: 30, height: 30,
                            decoration: BoxDecoration(color: c, shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: c.withValues(alpha: 0.4), blurRadius: 8)]),
                            child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.item.name,
                        style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w700, fontSize: 13.5),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text(widget.item.description,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                      const Spacer(),
                      Row(
                        children: [
                          Text('\$${widget.item.price.toStringAsFixed(2)}',
                            style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: 15)),
                          const Spacer(),
                          // Rating chip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFFFFF9E6), borderRadius: BorderRadius.circular(6)),
                            child: const Row(children: [
                              Icon(Icons.star_rounded, size: 11, color: Color(0xFFF59E0B)),
                              SizedBox(width: 2),
                              Text('4.8', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 10.5, fontWeight: FontWeight.w700)),
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), shape: BoxShape.circle),
            child: const Icon(Icons.search_off_rounded, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          const Text('No items found', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Try a different search or category.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
        ],
      ),
    );
  }
}
