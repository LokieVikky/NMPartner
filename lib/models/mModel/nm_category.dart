import 'package:equatable/equatable.dart';

class NMCategory extends Equatable {
  final String? categoryID;
  final String? name, description, icon;
  final bool? enabled;

  NMCategory({this.categoryID, this.name, this.description, this.icon, this.enabled});

  factory NMCategory.fromJson(Map<String, dynamic> json) {
    return NMCategory(
      categoryID: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      enabled: json['enabled'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": categoryID,
        "name": name,
        "description": description,
        "icon": icon,
        "enabled": enabled,
      };

  @override
  String toString() {
    return categoryID ?? '';
  }

  @override
  List<Object?> get props => [categoryID, name, description, icon, enabled];
}
