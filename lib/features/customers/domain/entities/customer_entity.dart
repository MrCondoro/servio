import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String email;
  final int totalOrders;
  final int loyaltyPoints;

  const CustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.totalOrders = 0,
    this.loyaltyPoints = 0,
  });

  @override
  List<Object?> get props => [id, name, phone, email, totalOrders, loyaltyPoints];
}
