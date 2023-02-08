class NMCategory {
  String? categoryID;
  String? name, description, icon;
  bool? open;

  NMCategory({
    this.categoryID, this.name, this.description, this.icon, this.open});

  factory NMCategory.fromJson(Map<String, dynamic> json) {
    return NMCategory(
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

  @override
  String toString() {
    return categoryID??'';
  }
}
