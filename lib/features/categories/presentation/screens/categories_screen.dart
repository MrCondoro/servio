import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

// ── Category data model ───────────────────────────────────────────────────────
class _Category {
  String name;
  Color color;
  IconData icon;
  int itemCount;
  _Category({required this.name, required this.color, required this.icon, this.itemCount = 0});
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _search = '';
  final List<_Category> _categories = [
    _Category(name: 'Pizza', color: const Color(0xFFEF4444), icon: Icons.local_pizza_rounded, itemCount: 12),
    _Category(name: 'Burgers', color: const Color(0xFFF59E0B), icon: Icons.lunch_dining_rounded, itemCount: 8),
    _Category(name: 'Coffee', color: const Color(0xFF92400E), icon: Icons.coffee_rounded, itemCount: 15),
    _Category(name: 'Desserts', color: const Color(0xFFEC4899), icon: Icons.cake_rounded, itemCount: 9),
    _Category(name: 'Drinks', color: const Color(0xFF3B82F6), icon: Icons.local_drink_rounded, itemCount: 20),
    _Category(name: 'Sandwiches', color: const Color(0xFF10B981), icon: Icons.lunch_dining_rounded, itemCount: 6),
    _Category(name: 'Pasta', color: const Color(0xFF8B5CF6), icon: Icons.ramen_dining_rounded, itemCount: 7),
    _Category(name: 'Breakfast', color: const Color(0xFFF97316), icon: Icons.free_breakfast_rounded, itemCount: 11),
    _Category(name: 'Salads', color: const Color(0xFF22C55E), icon: Icons.eco_rounded, itemCount: 5),
    _Category(name: 'Snacks', color: const Color(0xFF06B6D4), icon: Icons.fastfood_rounded, itemCount: 14),
  ];

  List<_Category> get _filtered => _categories
      .where((c) => _search.isEmpty || c.name.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  void _showCategoryDialog({_Category? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    Color selectedColor = existing?.color ?? AppColors.primary;
    IconData selectedIcon = existing?.icon ?? Icons.category_rounded;

    final colors = [
      const Color(0xFFEF4444), const Color(0xFFF59E0B), const Color(0xFF10B981),
      const Color(0xFF3B82F6), const Color(0xFF8B5CF6), const Color(0xFFEC4899),
      const Color(0xFFF97316), const Color(0xFF06B6D4), const Color(0xFF92400E),
      AppColors.primary,
    ];

    final icons = [
      Icons.local_pizza_rounded, Icons.lunch_dining_rounded, Icons.coffee_rounded,
      Icons.cake_rounded, Icons.local_drink_rounded, Icons.ramen_dining_rounded,
      Icons.free_breakfast_rounded, Icons.eco_rounded, Icons.fastfood_rounded,
      Icons.restaurant_rounded, Icons.rice_bowl_rounded, Icons.icecream_rounded,
      Icons.set_meal_rounded, Icons.bakery_dining_rounded, Icons.category_rounded,
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setDlgState) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 440,
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(existing == null ? 'New Category' : 'Edit Category',
                      style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 18)),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close_rounded, color: AppColors.textSecondaryLight)),
                  ],
                ),
                const SizedBox(height: 20),

                // Preview card
                Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: selectedColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                    child: Icon(selectedIcon, color: selectedColor, size: 40),
                  ),
                ),
                const SizedBox(height: 20),

                // Name field
                const Text('Category Name', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: AppColors.textPrimaryLight),
                  decoration: InputDecoration(
                    hintText: 'e.g. Pizza, Burgers...',
                    hintStyle: const TextStyle(color: AppColors.textSecondaryLight),
                    filled: true, fillColor: AppColors.backgroundLight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),

                // Color picker
                const Text('Color', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10, runSpacing: 10,
                  children: colors.map((c) {
                    final sel = selectedColor == c;
                    return GestureDetector(
                      onTap: () => setDlgState(() => selectedColor = c),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: c, shape: BoxShape.circle,
                          border: sel ? Border.all(color: AppColors.textPrimaryLight, width: 2.5) : null,
                        ),
                        child: sel ? const Icon(Icons.check_rounded, color: Colors.white, size: 16) : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Icon picker
                const Text('Icon', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: icons.map((ic) {
                    final sel = selectedIcon == ic;
                    return GestureDetector(
                      onTap: () => setDlgState(() => selectedIcon = ic),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: sel ? selectedColor.withValues(alpha: 0.12) : AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: sel ? selectedColor : AppColors.borderLight),
                        ),
                        child: Icon(ic, size: 20, color: sel ? selectedColor : AppColors.textSecondaryLight),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),

                Row(
                  children: [
                    if (existing != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() => _categories.remove(existing));
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.delete_outline_rounded, size: 16),
                          label: const Text('Delete'),
                          style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    if (existing != null) const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameCtrl.text.trim().isEmpty) return;
                          setState(() {
                            if (existing != null) {
                              existing.name = nameCtrl.text.trim();
                              existing.color = selectedColor;
                              existing.icon = selectedIcon;
                            } else {
                              _categories.add(_Category(name: nameCtrl.text.trim(), color: selectedColor, icon: selectedIcon));
                            }
                          });
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(existing == null ? 'Create Category' : 'Save Changes', style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
            color: Colors.white,
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 22)),
                    SizedBox(height: 2),
                    Text('Organize your menu into categories', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                  ],
                ),
                const Spacer(),
                // Search
                SizedBox(
                  width: 220, height: 40,
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Search categories...',
                      hintStyle: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
                      prefixIcon: const Icon(Icons.search_rounded, size: 17, color: AppColors.textSecondaryLight),
                      filled: true, fillColor: AppColors.backgroundLight,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _showCategoryDialog(),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('New Category', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12), elevation: 0,
                  ),
                ),
              ],
            ),
          ),

          // Stats bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                _StatChip(label: 'Total Categories', value: '${_categories.length}', color: AppColors.primary),
                const SizedBox(width: 12),
                _StatChip(label: 'Total Items', value: '${_categories.fold(0, (sum, c) => sum + c.itemCount)}', color: AppColors.success),
              ],
            ),
          ),
          const Divider(color: AppColors.borderLight, height: 1),

          // Grid
          Expanded(
            child: _filtered.isEmpty
                ? _EmptyState(onAdd: () => _showCategoryDialog())
                : GridView.builder(
                    padding: const EdgeInsets.all(28),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      mainAxisSpacing: 16, crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _CategoryCard(
                      category: _filtered[i],
                      onTap: () => _showCategoryDialog(existing: _filtered[i]),
                    ).animate().fadeIn(delay: (i * 40).ms, duration: 300.ms).scale(begin: const Offset(0.95, 0.95)),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final _Category category;
  final VoidCallback onTap;
  const _CategoryCard({required this.category, required this.onTap});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.category;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _hovered ? c.color : AppColors.borderLight, width: _hovered ? 1.5 : 1),
            boxShadow: _hovered ? [BoxShadow(color: c.color.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 6))] : [const BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(color: c.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(18)),
                child: Icon(c.icon, color: c.color, size: 32),
              ),
              const SizedBox(height: 14),
              Text(c.name, style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 15), textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text('${c.itemCount} items', style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 14, color: _hovered ? c.color : AppColors.textSecondaryLight),
                  const SizedBox(width: 4),
                  Text('Edit', style: TextStyle(color: _hovered ? c.color : AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), shape: BoxShape.circle),
            child: const Icon(Icons.category_outlined, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          const Text('No categories yet', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Create your first category to organize your menu.', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Category', style: TextStyle(fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
          ),
        ],
      ),
    );
  }
}
