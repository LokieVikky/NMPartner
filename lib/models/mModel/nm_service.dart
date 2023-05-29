import 'package:partner/services/apiService.dart';

class NMService {
  String? id;
  String? subCategoryId;
  String? name;
  String? rate;
  bool? rateConfigurable;

  NMService({this.id,this.subCategoryId,this.name,this.rate,this.rateConfigurable});

  NMService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryId = json['sub_category_id'];
    name = json['name'];
    rate = json['rate'];
    rateConfigurable = json['rate_configurable'];
  }
}

class ShopService {
  String? id;
  String? serviceId;
  String? shopId;
  String? rate;
  String? tax;
  String? amount;
  String? name;
  String? description;
  String? subCategoryId;

  ShopService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    shopId = json['shop_id'];
    rate = json['rate'];
    tax = json['tax'];
    amount = json['amount'];
    name = json['name'];
    description = json['description'];
    subCategoryId = json['sub_category_id'];
  }

  Map<String, dynamic> toJson() => {
        'service_id': serviceId,
        'shop_id': shopId,
        'rate': rate,
        'tax': tax,
        'amount': amount,
        'name': name,
        'description': description,
        'sub_category_id': subCategoryId,
      };
}

class ModelService {
  String _name;
  String _amount;
  bool _configurable;
  String? _id;
  bool _isSelected;
  bool? isCustom;

  String? subCategoryId = null;

  ModelService(this._name, this._amount, this._configurable, this._id, this._isSelected,
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
