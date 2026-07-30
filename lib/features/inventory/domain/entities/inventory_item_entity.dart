import 'package:equatable/equatable.dart';

class InventoryItemEntity extends Equatable {
  final String id;
  final String name;
  final double currentStock;
  final double minThreshold;
  final String unit;

  const InventoryItemEntity({
    required this.id,
    required this.name,
    required this.currentStock,
    required this.minThreshold,
    required this.unit,
  });

  bool get isLowStock => currentStock <= minThreshold;

  @override
  List<Object?> get props => [id, name, currentStock, minThreshold, unit];
}
