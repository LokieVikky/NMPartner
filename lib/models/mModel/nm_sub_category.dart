import 'package:equatable/equatable.dart';

class NMSubCategory extends Equatable {
  final String? subCategoryId;
  final String? subCategoryName;
  final String? subCategoryDesc;
  final String? subCategoryIcon;
  final String? categoryId;

  NMSubCategory(
      {this.subCategoryId,
      this.subCategoryName,
      this.subCategoryDesc,
      this.subCategoryIcon,
      this.categoryId});

  factory NMSubCategory.fromJson(Map<String, dynamic> json) {
    return NMSubCategory(
      subCategoryId: json['id'],
      subCategoryName: json['name'],
      subCategoryDesc: json['description'],
      subCategoryIcon: json['icon'],
      categoryId: json['category_id'],
    );
  }

  @override
  List<Object?> get props =>
      [subCategoryId, subCategoryName, subCategoryDesc, subCategoryIcon, categoryId];
}
