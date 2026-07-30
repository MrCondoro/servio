import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  // Basic info
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _barcodeCtrl = TextEditingController();
  final _caloriesCtrl = TextEditingController();
  final _prepTimeCtrl = TextEditingController();
  String _category = 'Pizza';
  String _status = 'Available';

  // Pricing
  final _priceCtrl = TextEditingController();
  final _costCtrl = TextEditingController();

  // Variants
  final List<Map<String, TextEditingController>> _variants = [];

  // Extras
  final List<Map<String, TextEditingController>> _extras = [];

  // Modifiers
  final List<Map<String, dynamic>> _modifierGroups = [];

  bool _variantsExpanded = true;
  bool _extrasExpanded = false;
  bool _modifiersExpanded = false;
  bool _ingredientsExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _addVariant();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _nameCtrl.dispose(); _descCtrl.dispose(); _skuCtrl.dispose();
    _barcodeCtrl.dispose(); _caloriesCtrl.dispose(); _prepTimeCtrl.dispose();
    _priceCtrl.dispose(); _costCtrl.dispose();
    super.dispose();
  }

  void _addVariant() {
    setState(() => _variants.add({
      'name': TextEditingController(text: _variants.isEmpty ? 'Medium' : ''),
      'price': TextEditingController(),
      'sku': TextEditingController(),
    }));
  }

  void _removeVariant(int i) {
    final v = _variants.removeAt(i);
    for (final c in v.values) c.dispose();
    setState(() {});
  }

  void _addExtra() {
    setState(() => _extras.add({
      'name': TextEditingController(),
      'price': TextEditingController(),
    }));
  }

  void _removeExtra(int i) {
    final e = _extras.removeAt(i);
    for (final c in e.values) c.dispose();
    setState(() {});
  }

  void _addModifierGroup() {
    setState(() => _modifierGroups.add({
      'name': TextEditingController(text: 'Spice Level'),
      'options': <String>['None', 'Mild', 'Medium', 'Hot'],
      'required': false,
    }));
  }

  double get _margin {
    final price = double.tryParse(_priceCtrl.text) ?? 0;
    final cost = double.tryParse(_costCtrl.text) ?? 0;
    return price > 0 ? ((price - cost) / price * 100) : 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1100;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimaryLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Add Product', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 17)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save Draft', style: TextStyle(color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check_rounded, size: 16),
              label: const Text('Publish', style: TextStyle(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.borderLight)),
      ),
      body: isDesktop ? _buildDesktop() : _buildMobile(),
    );
  }

  // ── Desktop: 3-column ─────────────────────────────────────────────────────
  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column 1: Basic Info
        Expanded(
          flex: 3,
          child: _buildBasicInfoPanel(),
        ),

        Container(width: 1, color: AppColors.borderLight),

        // Column 2: Media + Pricing + Status
        Expanded(
          flex: 2,
          child: _buildMediaAndPricingPanel(),
        ),

        Container(width: 1, color: AppColors.borderLight),

        // Column 3: Variants / Extras / Modifiers
        Expanded(
          flex: 3,
          child: _buildVariantsPanel(),
        ),
      ],
    );
  }

  // ── Mobile: tabbed ────────────────────────────────────────────────────────
  Widget _buildMobile() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabCtrl,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondaryLight,
            indicatorColor: AppColors.primary,
            tabs: const [Tab(text: 'Info & Pricing'), Tab(text: 'Variants & Extras')],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              SingleChildScrollView(
                child: Column(children: [_buildBasicInfoPanel(), _buildMediaAndPricingPanel()]),
              ),
              _buildVariantsPanel(),
            ],
          ),
        ),
      ],
    );
  }

  // ── Column 1: Basic Info ──────────────────────────────────────────────────
  Widget _buildBasicInfoPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(label: 'Basic Information'),
          const SizedBox(height: 16),

          _PFormField(ctrl: _nameCtrl, label: 'Product Name *', hint: 'e.g. Margherita Pizza', icon: Icons.fastfood_rounded),
          const SizedBox(height: 14),

          // Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FieldLabel('Description'),
              const SizedBox(height: 6),
              TextField(
                controller: _descCtrl,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13),
                decoration: _inputDeco('A delicious hand-crafted pizza...'),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Category + Status row
          Row(
            children: [
              Expanded(child: _DropdownField(
                label: 'Category',
                value: _category,
                items: const ['Pizza', 'Burgers', 'Coffee', 'Desserts', 'Drinks', 'Pasta', 'Other'],
                onChanged: (v) => setState(() => _category = v),
              )),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Status'),
                  const SizedBox(height: 6),
                  Row(
                    children: ['Available', 'Hidden'].map((s) {
                      final sel = _status == s;
                      return Expanded(child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: GestureDetector(
                          onTap: () => setState(() => _status = s),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: sel ? _statusColor(s).withValues(alpha: 0.1) : AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: sel ? _statusColor(s) : AppColors.borderLight),
                            ),
                            child: Text(s, textAlign: TextAlign.center, style: TextStyle(color: sel ? _statusColor(s) : AppColors.textSecondaryLight, fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
                          ),
                        ),
                      ));
                    }).toList(),
                  ),
                ],
              )),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(child: _PFormField(ctrl: _skuCtrl, label: 'SKU', hint: 'PIZ-001', icon: Icons.qr_code_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _PFormField(ctrl: _barcodeCtrl, label: 'Barcode', hint: '1234567890', icon: Icons.barcode_reader)),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(child: _PFormField(ctrl: _prepTimeCtrl, label: 'Prep Time (min)', hint: '15', icon: Icons.timer_outlined, keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: _PFormField(ctrl: _caloriesCtrl, label: 'Calories (optional)', hint: '350 kcal', icon: Icons.local_fire_department_outlined, keyboardType: TextInputType.number)),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // ── Column 2: Media + Pricing ─────────────────────────────────────────────
  Widget _buildMediaAndPricingPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image upload area
          _SectionLabel(label: 'Product Images'),
          const SizedBox(height: 12),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
                  child: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary, size: 24),
                ),
                const SizedBox(height: 10),
                const Text('Click to upload or drag & drop', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                Text('PNG, JPG up to 5MB each', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Pricing
          _SectionLabel(label: 'Pricing'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _PFormField(ctrl: _priceCtrl, label: 'Selling Price *', hint: '0.00', icon: Icons.attach_money_rounded, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}))),
              const SizedBox(width: 12),
              Expanded(child: _PFormField(ctrl: _costCtrl, label: 'Cost Price', hint: '0.00', icon: Icons.money_off_rounded, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}))),
            ],
          ),
          const SizedBox(height: 12),

          // Margin indicator
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up_rounded, color: AppColors.success, size: 18),
                const SizedBox(width: 8),
                const Text('Profit Margin', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600, fontSize: 13)),
                const Spacer(),
                Text('${_margin.toStringAsFixed(1)}%', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w800, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Cooking instructions
          _SectionLabel(label: 'Cooking Instructions'),
          const SizedBox(height: 10),
          TextField(
            maxLines: 4,
            style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13),
            decoration: _inputDeco('Add any special cooking instructions for kitchen staff...'),
          ),
        ],
      ).animate().fadeIn(delay: 80.ms, duration: 400.ms),
    );
  }

  // ── Column 3: Variants / Extras / Modifiers ───────────────────────────────
  Widget _buildVariantsPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // ── Variants ─────────────────────────────────────────────────────
          _AccordionSection(
            title: 'Variants',
            subtitle: 'Size, options (Small, Medium, Large)',
            icon: Icons.tune_rounded,
            iconColor: const Color(0xFF8B5CF6),
            expanded: _variantsExpanded,
            onToggle: () => setState(() => _variantsExpanded = !_variantsExpanded),
            child: Column(
              children: [
                ..._variants.asMap().entries.map((e) {
                  final i = e.key;
                  final v = e.value;
                  return _VariantRow(
                    index: i + 1,
                    nameCtrl: v['name']!,
                    priceCtrl: v['price']!,
                    skuCtrl: v['sku']!,
                    onRemove: _variants.length > 1 ? () => _removeVariant(i) : null,
                  );
                }),
                const SizedBox(height: 12),
                _AddRowButton(label: 'Add Variant', onTap: _addVariant),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Extras / Add-ons ──────────────────────────────────────────────
          _AccordionSection(
            title: 'Extras & Add-ons',
            subtitle: 'Extra cheese, sauce, toppings',
            icon: Icons.add_circle_outline_rounded,
            iconColor: AppColors.warning,
            expanded: _extrasExpanded,
            onToggle: () => setState(() => _extrasExpanded = !_extrasExpanded),
            child: Column(
              children: [
                if (_extras.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('No extras added yet.', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                  ),
                ..._extras.asMap().entries.map((e) {
                  final i = e.key;
                  final ex = e.value;
                  return _ExtraRow(
                    index: i + 1,
                    nameCtrl: ex['name']!,
                    priceCtrl: ex['price']!,
                    onRemove: () => _removeExtra(i),
                  );
                }),
                const SizedBox(height: 12),
                _AddRowButton(label: 'Add Extra', onTap: _addExtra),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Modifiers ─────────────────────────────────────────────────────
          _AccordionSection(
            title: 'Modifiers',
            subtitle: 'Spice level, sugar level, doneness',
            icon: Icons.settings_outlined,
            iconColor: AppColors.info,
            expanded: _modifiersExpanded,
            onToggle: () => setState(() => _modifiersExpanded = !_modifiersExpanded),
            child: Column(
              children: [
                if (_modifierGroups.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('No modifier groups added yet.', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                  ),
                ..._modifierGroups.map((g) => _ModifierGroupCard(group: g)),
                const SizedBox(height: 12),
                _AddRowButton(label: 'Add Modifier Group', onTap: _addModifierGroup),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Ingredients ───────────────────────────────────────────────────
          _AccordionSection(
            title: 'Ingredients',
            subtitle: 'Auto-deduct from inventory after sale',
            icon: Icons.inventory_2_outlined,
            iconColor: AppColors.success,
            expanded: _ingredientsExpanded,
            onToggle: () => setState(() => _ingredientsExpanded = !_ingredientsExpanded),
            child: Column(
              children: [
                ...['Bread', 'Beef Patty', 'Cheese', 'Tomato', 'Lettuce'].map((ing) =>
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)),
                    child: Row(
                      children: [
                        const Icon(Icons.grain_rounded, size: 14, color: AppColors.textSecondaryLight),
                        const SizedBox(width: 10),
                        Text(ing, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13)),
                        const Spacer(),
                        Text('100g', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                        const SizedBox(width: 8),
                        const Icon(Icons.close_rounded, size: 15, color: AppColors.textSecondaryLight),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _AddRowButton(label: 'Link Ingredient', onTap: () {}),
              ],
            ),
          ),
        ],
      ).animate().fadeIn(delay: 120.ms, duration: 400.ms),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Available': return AppColors.success;
      case 'Unavailable': return AppColors.error;
      case 'Hidden': return AppColors.textSecondaryLight;
      default: return AppColors.textSecondaryLight;
    }
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
      filled: true, fillColor: AppColors.backgroundLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    );
  }
}

// ── Accordion Section ─────────────────────────────────────────────────────────
class _AccordionSection extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color iconColor;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;
  const _AccordionSection({required this.title, required this.subtitle, required this.icon, required this.iconColor, required this.expanded, required this.onToggle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(icon, color: iconColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 14)),
                        Text(subtitle, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondaryLight),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(color: AppColors.borderLight, height: 1),
            Padding(padding: const EdgeInsets.all(16), child: child),
          ],
        ],
      ),
    );
  }
}

// ── Variant row ───────────────────────────────────────────────────────────────
class _VariantRow extends StatelessWidget {
  final int index;
  final TextEditingController nameCtrl, priceCtrl, skuCtrl;
  final VoidCallback? onRemove;
  const _VariantRow({required this.index, required this.nameCtrl, required this.priceCtrl, required this.skuCtrl, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 24, height: 24, decoration: BoxDecoration(color: const Color(0xFF8B5CF6).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Center(child: Text('$index', style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 11, fontWeight: FontWeight.w800)))),
              const SizedBox(width: 8),
              const Text('Variant', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600, fontSize: 13)),
              const Spacer(),
              if (onRemove != null) IconButton(icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.error), onPressed: onRemove, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(flex: 2, child: _MiniField(ctrl: nameCtrl, hint: 'Name (e.g. Medium)')),
              const SizedBox(width: 8),
              Expanded(child: _MiniField(ctrl: priceCtrl, hint: 'Price', keyboardType: TextInputType.number, prefix: '\$')),
              const SizedBox(width: 8),
              Expanded(child: _MiniField(ctrl: skuCtrl, hint: 'SKU')),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Extra row ─────────────────────────────────────────────────────────────────
class _ExtraRow extends StatelessWidget {
  final int index;
  final TextEditingController nameCtrl, priceCtrl;
  final VoidCallback onRemove;
  const _ExtraRow({required this.index, required this.nameCtrl, required this.priceCtrl, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        children: [
          Expanded(flex: 2, child: _MiniField(ctrl: nameCtrl, hint: 'Extra name (e.g. Extra Cheese)')),
          const SizedBox(width: 8),
          Expanded(child: _MiniField(ctrl: priceCtrl, hint: '+ Price', prefix: '\$', keyboardType: TextInputType.number)),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.error), onPressed: onRemove, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
        ],
      ),
    );
  }
}

// ── Modifier group card ───────────────────────────────────────────────────────
class _ModifierGroupCard extends StatelessWidget {
  final Map<String, dynamic> group;
  const _ModifierGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final ctrl = group['name'] as TextEditingController;
    final options = group['options'] as List<String>;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MiniField(ctrl: ctrl, hint: 'Group name (e.g. Spice Level)'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6, runSpacing: 6,
            children: options.map((o) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.borderLight)),
              child: Text(o, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 12)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Mini field ────────────────────────────────────────────────────────────────
class _MiniField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final TextInputType? keyboardType;
  final String? prefix;
  const _MiniField({required this.ctrl, required this.hint, this.keyboardType, this.prefix});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
        prefixText: prefix,
        prefixStyle: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13),
        filled: true, fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );
  }
}

// ── Add row button ────────────────────────────────────────────────────────────
class _AddRowButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AddRowButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 15));
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w600));
  }
}

class _PFormField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label, hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  const _PFormField({required this.ctrl, required this.label, required this.hint, required this.icon, this.keyboardType, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
            prefixIcon: Icon(icon, size: 16, color: AppColors.textSecondaryLight),
            filled: true, fillColor: AppColors.backgroundLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label, value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const _DropdownField({required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: (v) => onChanged(v!),
          style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13),
          decoration: InputDecoration(
            filled: true, fillColor: AppColors.backgroundLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          ),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        ),
      ],
    );
  }
}
