class ItemCategory {
  ItemCategory(this._id, this._name, this._isSelected, this._itemSubCategories);

  late final String _id;
  late final String _name;
  bool _isSelected = false;
  late List<ItemSubCategories> _itemSubCategories;

  ItemCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    itemSubCategories = List.from(json['item_sub_categories'])
        .map((e) => ItemSubCategories.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['item_sub_categories'] =
        itemSubCategories.map((e) => e.toJson()).toList();
    return _data;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  List<ItemSubCategories> get itemSubCategories => _itemSubCategories;

  set itemSubCategories(List<ItemSubCategories> value) {
    _itemSubCategories = value;
  }
}

class ItemSubCategories {
  late final String _id;
  late final String _name;
  late final String _categoryId;
  bool _isSelected = false;
  late List<ItemSubCategoryBrands> _itemSubCategoryBrands;

  ItemSubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    itemSubCategoryBrands = List.from(json['item_sub_category_brands'])
        .map((e) => ItemSubCategoryBrands.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['category_id'] = categoryId;
    _data['item_sub_category_brands'] =
        itemSubCategoryBrands.map((e) => e.toJson()).toList();
    return _data;
  }

  ItemSubCategories(
      this._id, this._name, this._categoryId, this._itemSubCategoryBrands);


  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get categoryId => _categoryId;

  set categoryId(String value) {
    _categoryId = value;
  }

  List<ItemSubCategoryBrands> get itemSubCategoryBrands =>
      _itemSubCategoryBrands;

  set itemSubCategoryBrands(List<ItemSubCategoryBrands> value) {
    _itemSubCategoryBrands = value;
  }
}

class ItemSubCategoryBrands {
  ItemSubCategoryBrands({
    required this.brand,
  });

   Brand? brand;

  ItemSubCategoryBrands.fromJson(Map<String, dynamic> json) {
    brand = Brand.fromJson(json['brand']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['brand'] = brand!.toJson();
    return _data;
  }
}

class Brand {
  Brand(this._name, this._id);

  late final String _name;
  String? _id;
  bool _isSelected = false;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  Brand.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['id'] = id;
    return _data;
  }

  String get id => _id!;

  set id(String value) {
    _id = value;
  }
}

//
// class CategoryModel {
//   String? catId;
//   String? catName;
//   String? catDescription;
//   bool? catEnabled;
//   String? catIcon;
//   bool? catIsHighlighted;
//
//   List<SubCategory>? subcategories;
//
//   CategoryModel(
//       {this.catId,
//       this.catName,
//       this.catDescription,
//       this.catEnabled,
//       this.catIcon,
//       this.catIsHighlighted,
//       this.subcategories});
// }
//
// class SubCategory {
//   String? subCatId;
//   String? subCatName;
//   String? subCatDescription;
//   bool? subCatEnabled;
//   String? subCatIcon;
//   String? subCatCatId;
//
//   List<Brands>? brands;
//
//   SubCategory(
//       {this.subCatId,
//       this.subCatName,
//       this.subCatDescription,
//       this.subCatEnabled,
//       this.subCatIcon,
//       this.subCatCatId,
//       this.brands});
// }
//
// class Brands {
//   String? brandId;
//   String? brandName;
//   String? brandIcon;
//   String? brandEnabled;
//   String? brandDescription;
//
//   Brands(
//       {this.brandId,
//       this.brandName,
//       this.brandIcon,
//       this.brandEnabled,
//       this.brandDescription});
// }
