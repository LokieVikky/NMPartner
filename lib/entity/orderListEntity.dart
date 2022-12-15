class OrderListEntity {
  String? orderId;
  String? description;
  String? amount;
  String? placedOn;
  String? customerId;

  String? orderStatus;

  OrderListEntity(
      {this.orderId,
      this.description,
      this.amount,
      this.placedOn,
      this.customerId,
      this.orderStatus});
}
