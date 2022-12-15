import 'package:partner/services/apiService.dart';

class ModelService {
  String _name;
  String _amount;
  bool _configurable;
  String? _id;
  bool _isSelected;
  bool? isCustom;

  String? subCategoryId = null;

  ModelService(
      this._name, this._amount, this._configurable, this._id, this._isSelected,
      {this.isCustom});
  /*amount: $amount, description: $description,
  name: $name, service_id: "", shop_id: "", sub_category_id: ""*/
   toJson() async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this._amount;
    data['description'] = null;
    data['name'] = this._name;
    data['service_id'] = this._id;
    data['shop_id'] = await ApiService().readShopId();
    data['sub_category_id'] = this.subCategoryId;
    return data;
  }

  bool get isSelected => _isSelected;

  void setBool(bool value) {
    _isSelected = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get amount => _amount;

  String get id => _id!;

  set id(String value) {
    _id = value;
  }

  bool get configurable => _configurable;

  set configurable(bool value) {
    _configurable = value;
  }

  set amount(String value) {
    _amount = value;
  }

  setSubCategory(String subCategory) {
    subCategoryId = subCategory;
  }
}

class ModelSelectedSubCategory {
  String? name;
  String? id;

  ModelSelectedSubCategory(this.name, this.id);
}
