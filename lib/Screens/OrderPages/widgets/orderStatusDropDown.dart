import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/entity/orderListEntity.dart';

import '../../../provider/mProvider/commanProviders.dart';
import '../../../provider/mProvider/ordersProvider.dart';

class OrderStatusDropDown extends ConsumerStatefulWidget {
  List<String>? statusList = [];
  OrderListEntity? data;

  OrderStatusDropDown(this.data, {Key? key}) : super(key: key);

  @override
  _OrderStatusDropDownState createState() => _OrderStatusDropDownState();
}

class _OrderStatusDropDownState extends ConsumerState<OrderStatusDropDown> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref.read(statusListNotifierProvider.notifier).getOrdersList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      widget.statusList = ref.watch(statusListNotifierProvider);
      print(widget.statusList!.length.toString());
      return Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
                items: widget.statusList!
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(widget.data!.orderStatus.toString()),
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow, width: 1.0)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow, width: 1.0)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow, width: 1.0))
                ),
                onChanged: (val) =>
                    ref.read(orderStatusDropdownItem.notifier).state = val!),
          ),
        ],
      );
    });
  }
}
