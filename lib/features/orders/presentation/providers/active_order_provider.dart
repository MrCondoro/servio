import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../../domain/entities/order_entity.dart';

part 'active_order_provider.g.dart';

@riverpod
class ActiveOrderController extends _$ActiveOrderController {
  @override
  OrderEntity build() {
    return OrderEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderNumber: '0001', // Should ideally be auto-incremented via backend
      items: const [],
      createdAt: DateTime.now(),
    );
  }

  void setTable(String tableId) {
    state = state.copyWith(tableId: tableId);
  }

  void addItem(MenuItemEntity menuItem) {
    final existingIndex = state.items.indexWhere((item) => item.menuItemId == menuItem.id);

    List<OrderItemEntity> updatedItems = List.from(state.items);

    if (existingIndex >= 0) {
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      updatedItems.add(
        OrderItemEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          menuItemId: menuItem.id,
          name: menuItem.name,
          price: menuItem.price,
          quantity: 1,
        ),
      );
    }

    state = state.copyWith(items: updatedItems);
  }

  void removeItem(String orderItemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != orderItemId).toList(),
    );
  }

  void updateQuantity(String orderItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(orderItemId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.id == orderItemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void addNote(String orderItemId, String note) {
    final updatedItems = state.items.map((item) {
      if (item.id == orderItemId) {
        return item.copyWith(notes: note);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void clearOrder() {
    state = OrderEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderNumber: '0001',
      items: const [],
      createdAt: DateTime.now(),
    );
  }
}
