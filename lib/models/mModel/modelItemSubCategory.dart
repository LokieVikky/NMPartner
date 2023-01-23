class ModelItemSubCategory {
  String? subCategoryId;
  String? subCategoryName;
  String? subCategoryDesc;
  bool? subCategoryEnabled;
  String? subCategoryIcon;
  String? subCategoryCategoryId;
  bool? subCategoryIsSelected;

  ModelItemSubCategory(
      {this.subCategoryId,
      this.subCategoryName,
      this.subCategoryDesc,
      this.subCategoryEnabled,
      this.subCategoryIcon,
      this.subCategoryIsSelected,
      this.subCategoryCategoryId});

  factory ModelItemSubCategory.fromJson(Map<String, dynamic> json) {
    return ModelItemSubCategory(
      subCategoryId: json['id'],
      subCategoryName: json['name'],
      subCategoryDesc: json['description'],
      subCategoryIcon: json['icon'],
      subCategoryCategoryId: json['category_id'],
    );
  }
}