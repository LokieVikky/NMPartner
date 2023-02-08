class SubCategory {
  String? subCategoryId;
  String? subCategoryName;
  String? subCategoryDesc;
  bool? subCategoryEnabled;
  String? subCategoryIcon;
  String? subCategoryCategoryId;
  bool? subCategoryIsSelected;

  SubCategory(
      {this.subCategoryId,
      this.subCategoryName,
      this.subCategoryDesc,
      this.subCategoryEnabled,
      this.subCategoryIcon,
      this.subCategoryIsSelected,
      this.subCategoryCategoryId});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      subCategoryId: json['id'],
      subCategoryName: json['name'],
      subCategoryDesc: json['description'],
      subCategoryIcon: json['icon'],
      subCategoryCategoryId: json['category_id'],
    );
  }

  @override
  String toString() {
    return subCategoryId ?? '';
  }
}
