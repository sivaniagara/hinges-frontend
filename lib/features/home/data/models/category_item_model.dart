import '../../domain/entities/category_item_entity.dart';

class CategoryItemModel extends CategoryItemEntity {
  const CategoryItemModel({
    required super.id,
    required super.categoryId,
    required super.categoryItemName,
  });

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      id: json['_id'] ?? '',
      categoryId: json['category_id'] ?? '',
      categoryItemName: json['category_item_name'] ?? '',
    );
  }
}
