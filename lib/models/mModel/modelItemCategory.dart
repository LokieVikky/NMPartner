class ModelItemCategory {
  String? categoryId;
  String? categoryName;
  String? categoryDesc;
  bool? categoryEnabled;
  String? categoryIcon;
  bool? categoryIsHighlighted;
  bool? categoryIsSelected;

  ModelItemCategory(
      {this.categoryId,
      this.categoryName,
      this.categoryDesc,
      this.categoryEnabled,
      this.categoryIcon,
      this.categoryIsSelected,
      this.categoryIsHighlighted});
}