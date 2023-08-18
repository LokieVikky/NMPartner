import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/provider/providers.dart';
import 'package:partner/shared/custom_widgets.dart';
import 'package:partner/state/orderListState.dart';
import 'package:partner/values/MyColors.dart';

import '../../../provider/mProvider/ordersProvider.dart';
import 'ongoingOrders.dart';

class PendingOrdersPage extends ConsumerStatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends ConsumerState<PendingOrdersPage> {
  bool isEmpty = true;
  Map<int, int> mMap = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (context) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pending Orders",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.purple,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Expanded(
                child: Builder(builder: (context) {
                  return ref.watch(shopIdProvider).when(
                        data: (shopId) {
                          if (shopId == null) {
                            return AppErrorWidget(
                              errorText: 'Something went wrong',
                              onPressed: () => ref.refresh(shopIdProvider),
                            );
                          }
                          return ref.watch(ordersProvider(shopId)).when(
                                data: (data) {
                                  return RefreshIndicator(
                                    child: Builder(
                                      builder: (context) {
                                        if (data.isEmpty) {
                                          return CustomScrollView(
                                            slivers: [
                                              SliverFillRemaining(
                                                child: Center(
                                                  child: AppErrorWidget(
                                                    errorText:
                                                        'No pending orders',
                                                    onPressed: () {
                                                      ref.invalidate(
                                                          ordersProvider(
                                                              shopId));
                                                      //ref.refresh(shopIdProvider);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        return ListView.builder(
                                          itemBuilder: (context, index) {
                                            return OnGoingOrderCard(
                                              entity: data[index],
                                              screenType: 0,
                                            );
                                          },
                                          itemCount: data.length,
                                        );
                                      },
                                    ),
                                    onRefresh: () async {
                                      ref.invalidate(ordersProvider(shopId));
                                      return Future.value(true);
                                    },
                                  );
                                },
                                error: (error, stackTrace) => Center(
                                  child: AppErrorWidget(
                                    errorText: error.toString(),
                                    onPressed: () =>
                                        ref.refresh(shopIdProvider),
                                  ),
                                ),
                                loading: () => Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              );
                        },
                        error: (error, stackTrace) => Center(
                          child: AppErrorWidget(
                            errorText: error.toString(),
                            onPressed: () => ref.refresh(shopIdProvider),
                          ),
                        ),
                        loading: () => Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

}
