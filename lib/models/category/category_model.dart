import 'package:hive_flutter/adapters.dart';
part 'category_model.g.dart';

@HiveType(typeId: 1)
enum categoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 2)
class CategoryModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(3)
  final bool isDeleted;
  @HiveField(2)
  final categoryType type;

  CategoryModel({
    required this.id,
    required this.name,
    this.isDeleted = false,
    required this.type,
  });
}
