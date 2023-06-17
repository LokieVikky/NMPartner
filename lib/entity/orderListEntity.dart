class WorkOrder {
  String? orderId;
  String? description;
  String? amount;
  String? consumerId;
  String? lastUpdatedOn;
  String? pickup;
  String? pickupDetailId;
  String? placedOn;
  String? remarks;

  WorkOrder(
      {this.orderId,
      this.description,
      this.amount,
      this.consumerId,
      this.lastUpdatedOn,
      this.pickup,
      this.pickupDetailId,
      this.placedOn,
      this.remarks});

  WorkOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['id'];
    description = json['description'];
    amount = json['amount'];
    consumerId = json['consumer_id'];
    lastUpdatedOn = json['latest_update_on'];
    pickup = json['pickup'];
    pickupDetailId = json['pickup_drop_details_id'];
    placedOn = json['placedOn'];
    remarks = json['remarks'];
  }
}
