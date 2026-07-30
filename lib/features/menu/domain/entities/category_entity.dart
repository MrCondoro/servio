import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String? iconUrl;
  final int order;
  final bool isActive;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.iconUrl,
    this.order = 0,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, iconUrl, order, isActive];
}
