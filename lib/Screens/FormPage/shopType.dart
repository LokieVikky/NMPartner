import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:partner/Screens/FormPage/widgets/shopCategory.dart';
import 'package:partner/Screens/FormPage/widgets/shopServices.dart';
import 'package:partner/models/mModel/modelCategory.dart';
import 'package:partner/provider/mProvider/serviceProvider.dart';

import '../../provider/mProvider/currentStepProvider.dart';
import '../../provider/mProvider/selectionProvider.dart';
import '../../provider/mProvider/shopCategory.dart';
import '../../values/MyColors.dart';
import '../../values/MyTextstyle.dart';

class ShopType extends ConsumerStatefulWidget {
  ShopType({Key? key}) : super(key: key);

  @override
  _ShopServicesState createState() => _ShopServicesState();
}

class _ShopServicesState extends ConsumerState<ShopType> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShopCategory(),
          SizedBox(height: 20.0),
          ShopServices(),
          StreamBuilder(
            builder: (context, snapshot) {
              ShopCategoryState state =
                  ref.watch(shopCategoryNotifierProvider)!;
              switch (state.status) {
                case UpdateShopCategoryStatus.initial:
                case UpdateShopCategoryStatus.failure:
                case UpdateShopCategoryStatus.success:
                  return GestureDetector(
                    onTap: () async {
                      ref.read(shopCategoryNotifierProvider.notifier).setLoadingState();

                      List<ItemCategory> categoryList =
                          await ref.read(getAllCategoryNotifierProvider);
                      List<String> selectedCategory = [];
                      List<String> selectedSubCategory = [];
                      List<String> selectedBrand = [];
                      for (ItemCategory category in categoryList) {
                        if (category.isSelected) {
                          selectedCategory.add(category.id);
                          for (ItemSubCategories subCategory
                              in category.itemSubCategories) {
                            if (subCategory.isSelected) {
                              selectedSubCategory.add(subCategory.id);
                              for (ItemSubCategoryBrands brand
                                  in subCategory.itemSubCategoryBrands) {
                                if (brand.brand!.isSelected) {
                                  selectedBrand.add(brand.brand!.id);
                                }
                              }
                            }
                          }
                        }
                      }
                      var selectedServices = await ref
                          .read(selectedServiceNotifierProvider.notifier)
                          .state;

                      if (selectedBrand.isNotEmpty &&
                          selectedServices.isNotEmpty) {
                        var res = await ref
                            .read(shopCategoryNotifierProvider.notifier)
                            .insertShoptype(null, selectedSubCategory,
                                selectedBrand, selectedServices);
                        print(categoryList);

                        if (res != null) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/homePage', (Route<dynamic> route) => false);
                          print('');
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please select shop type & shop services !",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: MyColors.yellow,
                            textColor: Colors.black,
                            fontSize: 20.0);
                      }
                    },
                    child: Container(
                      height: _height / 15,
                      width: _width,
                      margin: EdgeInsets.only(
                        top: 10.0,
                        bottom: 5.0,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        color: MyColors.yellow,
                      ),
                      child: Text(
                        "SAVE",
                        style: MyTextStyle.button1,
                      ),
                    ),
                  );
                case UpdateShopCategoryStatus.loading:
                  return Container(
                    height: _height / 15,
                    width: _width,
                    margin: EdgeInsets.only(
                      top: 10.0,
                      bottom: 5.0,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      color: MyColors.yellow,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(
                          color: MyColors.pureblack, strokeWidth: 2),
                    ),
                  );
              }
            },
          )
        ],
      ),
    );
  }
}
