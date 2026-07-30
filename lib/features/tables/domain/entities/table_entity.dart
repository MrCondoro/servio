import 'package:equatable/equatable.dart';

enum TableStatus { available, occupied, reserved }

class TableEntity extends Equatable {
  final String id;
  final String name;
  final String zone;
  final int capacity;
  final TableStatus status;

  const TableEntity({
    required this.id,
    required this.name,
    this.zone = 'Main',
    this.capacity = 4,
    this.status = TableStatus.available,
  });

  @override
  List<Object?> get props => [id, name, zone, capacity, status];
}
