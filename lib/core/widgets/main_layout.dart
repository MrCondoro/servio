import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../theme/app_colors.dart';

class MainLayout extends ConsumerStatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  bool _sidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: _sidebarCollapsed ? 72 : 240,
              child: _buildSidebar(context, currentRoute),
            ),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context, isDesktop),
                Expanded(
                  child: Container(
                    color: AppColors.backgroundLight,
                    child: widget.child
                        .animate(key: ValueKey(currentRoute))
                        .fadeIn(duration: 200.ms),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isDesktop ? _buildBottomNav(context, currentRoute) : null,
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDesktop) {
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dateStr = 'Today, ${months[now.month - 1]} ${now.day}, ${now.year}';

    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (isDesktop) ...[
            GestureDetector(
              onTap: () => setState(() => _sidebarCollapsed = !_sidebarCollapsed),
              child: const Icon(Icons.menu_rounded, color: AppColors.textSecondaryLight, size: 22),
            ),
            const SizedBox(width: 20),
          ],

          // Restaurant selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.store_rounded, size: 16, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Bella Vista', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimaryLight)),
                SizedBox(width: 6),
                Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondaryLight),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Date chip — only visible on wide screens
          if (MediaQuery.of(context).size.width > 1100)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.textSecondaryLight),
                const SizedBox(width: 5),
                Text(dateStr, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w500)),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Shift chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time_rounded, size: 13, color: AppColors.primary),
                SizedBox(width: 5),
                Text('Morning Shift', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          const Spacer(),

          // Search
          Container(
            width: 200,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                prefixIcon: Icon(Icons.search_rounded, size: 16, color: AppColors.textSecondaryLight),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondaryLight, size: 22),
                onPressed: () => GoRouter.of(context).go('/notifications'),
              ),
              Positioned(
                top: 8, right: 8,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),

          // Avatar
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text('JS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, String currentRoute) {
    return Container(
      color: AppColors.header,
      child: Column(
        children: [
          // Logo
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.eco_rounded, color: AppColors.primary, size: 20),
                ),
                if (!_sidebarCollapsed) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Servio POS',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: -0.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Nav items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _navItem(context, 'Dashboard', Icons.space_dashboard_rounded, '/dashboard', currentRoute),
                if (!_sidebarCollapsed)
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 6, left: 12),
                    child: Text('MANAGEMENT', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  )
                else
                  const SizedBox(height: 16),
                _navItem(context, 'Orders', Icons.receipt_long_rounded, '/orders', currentRoute),
                _navItem(context, 'Tables', Icons.table_restaurant_rounded, '/tables', currentRoute),
                _navItem(context, 'Menu', Icons.restaurant_menu_rounded, '/menu', currentRoute),
                _navItem(context, 'Categories', Icons.category_rounded, '/categories', currentRoute),
                _navItem(context, 'Products', Icons.inventory_2_rounded, '/products', currentRoute),
                _navItem(context, 'Customers', Icons.people_alt_rounded, '/customers', currentRoute),
                _navItem(context, 'Employees', Icons.badge_rounded, '/employees', currentRoute),
                _navItem(context, 'Inventory', Icons.inventory_2_rounded, '/inventory', currentRoute),
                _navItem(context, 'KDS', Icons.kitchen_rounded, '/kds', currentRoute),
                if (!_sidebarCollapsed)
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 6, left: 12),
                    child: Text('FINANCE', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  )
                else
                  const SizedBox(height: 16),
                _navItem(context, 'Reports', Icons.bar_chart_rounded, '/reports', currentRoute),
                _navItem(context, 'Settings', Icons.settings_rounded, '/settings', currentRoute),
              ],
            ),
          ),

          // User profile
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.borderDark)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text('JS', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
                if (!_sidebarCollapsed) ...[
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Smith', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                        Text('Owner', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondaryDark, size: 18),
                    onPressed: () => ref.read(authRepositoryProvider).logout(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, IconData icon, String route, String currentRoute) {
    final isSelected = currentRoute == route || currentRoute.startsWith('$route/');
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Tooltip(
        message: _sidebarCollapsed ? title : '',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.go(route),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: _sidebarCollapsed ? 12 : 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 19, color: isSelected ? Colors.white : AppColors.textSecondaryDark),
                  if (!_sidebarCollapsed) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, String currentRoute) {
    int index = 0;
    if (currentRoute.startsWith('/orders')) index = 1;
    if (currentRoute.startsWith('/tables')) index = 2;
    if (currentRoute.startsWith('/menu')) index = 1;
    if (currentRoute.startsWith('/kds')) index = 3;
    if (currentRoute.startsWith('/settings')) index = 4;

    return NavigationBar(
      selectedIndex: index,
      backgroundColor: Colors.white,
      onDestinationSelected: (i) {
        switch (i) {
          case 0: context.go('/dashboard'); break;
          case 1: context.go('/menu'); break;
          case 2: context.go('/tables'); break;
          case 3: context.go('/kds'); break;
          case 4: context.go('/settings'); break;
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.space_dashboard_outlined), selectedIcon: Icon(Icons.space_dashboard_rounded), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.restaurant_menu_outlined), selectedIcon: Icon(Icons.restaurant_menu_rounded), label: 'Orders'),
        NavigationDestination(icon: Icon(Icons.table_restaurant_outlined), selectedIcon: Icon(Icons.table_restaurant_rounded), label: 'Tables'),
        NavigationDestination(icon: Icon(Icons.kitchen_outlined), selectedIcon: Icon(Icons.kitchen_rounded), label: 'KDS'),
        NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings_rounded), label: 'Settings'),
      ],
    );
  }
}
