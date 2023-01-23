class CategoryModel {
  var categoryID;
  String? name, description, icon;
  bool? open;

  CategoryModel({
    this.categoryID, this.name, this.description, this.icon, this.open});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryID: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      open: json['enabled'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": categoryID,
    "name": name,
    "description": description,
    "icon": icon,
    "enabled": open,
  };
}
