import 'package:equatable/equatable.dart';

class CategoryItemEntity extends Equatable {
  final String id;
  final String categoryId;
  final String categoryItemName;

  const CategoryItemEntity({
    required this.id,
    required this.categoryId,
    required this.categoryItemName,
  });

  @override
  List<Object?> get props => [id, categoryId, categoryItemName];
}
