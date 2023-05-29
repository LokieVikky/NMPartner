import 'package:partner/models/mModel/nm_service.dart';

class PendingOrderInfo {
  String? custName;
  String? customerId;
  String? custProfile;
  String? custPhone;
  String? dob;

  String? orderAmount;
  String? orderRate;
  String? orderTax;

  String? orderDescription;
  List<ModelService>? serviceModel;

  PendingOrderInfo(
      {this.custName,
      this.customerId,
      this.custProfile,
      this.orderAmount,
      this.orderRate,
      this.orderTax,
      this.orderDescription,
      this.serviceModel});
}