import 'package:equatable/equatable.dart';

enum OrderStatus { pending, preparing, ready, completed, cancelled }

class OrderItemEntity extends Equatable {
  final String id;
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String? notes;

  const OrderItemEntity({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.notes,
  });

  OrderItemEntity copyWith({
    String? id,
    String? menuItemId,
    String? name,
    double? price,
    int? quantity,
    String? notes,
  }) {
    return OrderItemEntity(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  double get total => price * quantity;

  @override
  List<Object?> get props => [id, menuItemId, name, price, quantity, notes];
}

class OrderEntity extends Equatable {
  final String id;
  final String? tableId;
  final String orderNumber;
  final OrderStatus status;
  final List<OrderItemEntity> items;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    this.tableId,
    required this.orderNumber,
    this.status = OrderStatus.pending,
    required this.items,
    required this.createdAt,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);

  // Example MVP simple tax logic
  double get tax => subtotal * 0.08; 

  double get total => subtotal + tax;

  OrderEntity copyWith({
    String? id,
    String? tableId,
    String? orderNumber,
    OrderStatus? status,
    List<OrderItemEntity>? items,
    DateTime? createdAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, tableId, orderNumber, status, items, createdAt];
}
