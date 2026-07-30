import 'package:equatable/equatable.dart';

class MenuItemEntity extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final bool isAvailable;

  const MenuItemEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        name,
        description,
        price,
        imageUrl,
        isAvailable,
      ];
}
