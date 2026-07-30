import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../orders/presentation/providers/active_order_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrder = ref.watch(activeOrderControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Row(
        children: [
          // Left Side: Order Summary
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Summary', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: activeOrder.items.length,
                      itemBuilder: (context, index) {
                        final item = activeOrder.items[index];
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text('Qty: \${item.quantity}'),
                          trailing: Text('\$\${item.total.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  _buildSummaryRow(context, 'Subtotal', activeOrder.subtotal),
                  _buildSummaryRow(context, 'Tax', activeOrder.tax),
                  const Divider(),
                  _buildSummaryRow(context, 'Total', activeOrder.total, isTotal: true),
                ],
              ),
            ),
          ),
          // Right Side: Payment Methods
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Payment Method', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: _PaymentMethodCard(
                          icon: Icons.money,
                          title: 'Cash',
                          onTap: () => _processPayment(context, ref, 'Cash'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _PaymentMethodCard(
                          icon: Icons.credit_card,
                          title: 'Card',
                          onTap: () => _processPayment(context, ref, 'Card'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _PaymentMethodCard(
                          icon: Icons.phone_android,
                          title: 'Mobile Pay',
                          onTap: () => _processPayment(context, ref, 'Mobile Pay'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Spacer(),
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

  Widget _buildSummaryRow(BuildContext context, String label, double amount, {bool isTotal = false}) {
    final style = isTotal
        ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.titleMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('\$\${amount.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }

  void _processPayment(BuildContext context, WidgetRef ref, String method) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Processing Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Processing \$method payment...'),
          ],
        ),
      ),
    );

    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pop(context); // close dialog
        ref.read(activeOrderControllerProvider.notifier).clearOrder();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful!')),
        );
        context.go('/dashboard');
      }
    });
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
