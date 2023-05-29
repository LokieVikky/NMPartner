import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/Screens/HomePages/homePage.dart';
import 'package:partner/models/mModel/nm_category.dart';
import 'package:partner/models/mModel/nm_service.dart';
import 'package:partner/models/mModel/nm_sub_category.dart';
import 'package:partner/provider/providers.dart';
import 'package:partner/provider/update_shop_controller.dart';
import 'package:partner/provider/update_shop_services_controller.dart';
import 'package:partner/shared/custom_widgets.dart';
import 'package:partner/values/MyColors.dart';
import 'package:partner/shared/async_value_ui.dart';
import '../../../models/mModel/modelCategory.dart';
import '../../../provider/mProvider/selectionProvider.dart';
import '../../../values/MyTextstyle.dart';

class RegisterShopServices extends ConsumerStatefulWidget {
  const RegisterShopServices({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterShopServices> createState() => _ShopCategoryState();
}

class _ShopCategoryState extends ConsumerState<RegisterShopServices> {
  final ValueNotifier<List<ItemCategory>>? categorySelector = ValueNotifier([]);
  final ValueNotifier<List<ItemSubCategories>>? subCategorySelector = ValueNotifier([]);
  final List<NMCategory> selectedCategory = [];
  final List<NMSubCategory> selectedSubcategory = [];
  final List<NMService> selectedService = [];

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(updateShopServicesControllerProvider, (_, state) {
      if (state is AsyncData) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => HomePage(),
        // ));
      }
      ref.refresh(registrationStatusProvider);
      state.showSnackBarOnError(context);
    });

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Type",
                      style: MyTextStyle.formHeading,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Category",
                      style: MyTextStyle.formSubHeading,
                    ),
                  ],
                ),
                _buildCategory(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Sub Category",
                      style: MyTextStyle.formSubHeading,
                    ),
                  ],
                ),
                _buildSubCategory(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Services",
                      style: MyTextStyle.formHeading,
                    ),
                  ],
                ),
                _buildServices(),
              ],
            ),
          ),
        ),
        _buildSaveButton()
      ],
    );
  }

  Widget _buildSaveButton() {
    final state = ref.watch(updateShopServicesControllerProvider);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: state.isLoading
          ? null
          : () {
              ref.read(shopIdProvider).maybeWhen(
                  orElse: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Something went wrong')));
                  },
                  data: (shopId) {
                    if (shopId == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Something went wrong')));
                      return;
                    }
                    ref
                        .read(updateShopServicesControllerProvider.notifier)
                        .updateShop(shopId, selectedService);
                  });
            },
      child: Container(
        height: _height / 15,
        width: _width,
        margin: EdgeInsets.only(
          top: 20.0,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          color: AppColors.yellow,
        ),
        child: state.isLoading
            ? Text(
                'Loading...',
                style: MyTextStyle.button1,
              )
            : Text(
                'Save',
                style: MyTextStyle.button1,
              ),
      ),
    );
  }

  Widget _buildCategory() {
    return ref.watch(categoriesProvider).when(data: (List<NMCategory> data) {
      return Wrap(
        spacing: 8,
        children: List.generate(
          data.length,
          (index) {
            NMCategory category = data[index];
            return ChoiceChip(
              selectedColor: Colors.blue,
              backgroundColor: Colors.yellow,
              label: Text(category.name ?? ''),
              selected: selectedCategory.contains(category),
              labelStyle: selectedCategory.contains(category)
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: Colors.black),
              onSelected: (bool value) {
                if (value) {
                  selectedCategory.add(category);
                } else {
                  selectedCategory.remove(category);
                }
                setState(() {});
              },
            );
          },
        ),
      );
    }, error: (error, stacktrace) {
      return AppErrorWidget(
        onPressed: () => ref.refresh(categoriesProvider),
      );
    }, loading: () {
      return CupertinoActivityIndicator();
    });
  }

  Widget _buildSubCategory() {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 100),
      child: ref.watch(subCategoriesProvider(SubCategoryProviderParam(selectedCategory))).when(
          data: (data) {
            return () {
              if (data.isEmpty) {
                return Center(child: Text('Select Category'));
              }
              return Wrap(
                spacing: 8,
                children: List.generate(data.length, (index) {
                  NMSubCategory subCategory = data[index];
                  return ChoiceChip(
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.yellow,
                    label: Text(subCategory.subCategoryName ?? ''),
                    labelStyle: selectedSubcategory.contains(subCategory)
                        ? TextStyle(color: Colors.white)
                        : TextStyle(color: Colors.black),
                    selected: selectedSubcategory.contains(subCategory),
                    onSelected: (bool value) {
                      if (value) {
                        selectedSubcategory.add(subCategory);
                      } else {
                        selectedSubcategory.remove(subCategory);
                      }
                      setState(() {});
                    },
                  );
                }),
              );
            }();
          },
          error: (_, __) => AppErrorWidget(
                onPressed: () =>
                    ref.refresh(subCategoriesProvider(SubCategoryProviderParam(selectedCategory))),
              ),
          loading: () {
            return Center(child: CupertinoActivityIndicator());
          }),
    );
  }

  Widget _buildServices() {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 100),
      child: ref.watch(servicesProvider(ServicesProviderParam(selectedSubcategory))).when(
          data: (data) {
            return () {
              if (selectedSubcategory.isEmpty) {
                return Center(child: Text('Select Sub Category'));
              }
              if (data.isEmpty) {
                return Center(child: Text('No services found'));
              }
              return Wrap(
                spacing: 8,
                children: List.generate(data.length, (index) {
                  NMService service = data[index];
                  return ChoiceChip(
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.yellow,
                    label: Text(service.name ?? ''),
                    labelStyle: selectedService.contains(service)
                        ? TextStyle(color: Colors.white)
                        : TextStyle(color: Colors.black),
                    selected: selectedService.contains(service),
                    onSelected: (bool value) {
                      if (value) {
                        selectedService.add(service);
                      } else {
                        selectedService.remove(service);
                      }
                      setState(() {});
                    },
                  );
                }),
              );
            }();
          },
          error: (_, __) => AppErrorWidget(
                onPressed: () =>
                    ref.refresh(servicesProvider(ServicesProviderParam(selectedSubcategory))),
              ),
          loading: () {
            return Center(child: CupertinoActivityIndicator());
          }),
    );
  }

  getCategoryItem(int index, var list, int type) {
    ItemCategory item = list[index];
    return GestureDetector(
      onTap: () {
        ref.read(getAllCategoryNotifierProvider.notifier).selectCategory(list[index].id);
      },
      child: Card(
        color: item.isSelected ? Colors.blue : Colors.yellow,
        child: Center(
            child: Text(
          item.name,
          textAlign: TextAlign.center,
          style: TextStyle(color: item.isSelected ? Colors.white : Colors.black),
        )),
      ),
    );
  }

  getSubCategoryItem(int index, List<ItemSubCategories> subCategoryList, int i) {
    ItemSubCategories item = subCategoryList[index];
    return GestureDetector(
      onTap: () {
        ref
            .read(getAllCategoryNotifierProvider.notifier)
            .selectSubCategory(subCategoryList[index].id);
      },
      child: Card(
        color: item.isSelected ? Colors.blue : Colors.yellow,
        child: Center(child: Text(item.name, textAlign: TextAlign.center)),
      ),
    );
  }

  getBrandItem(int index, List<Brand> brandList, int i) {
    Brand brand = brandList[index];
    return GestureDetector(
      onTap: () {
        ref.read(getAllCategoryNotifierProvider.notifier).selectBrand(brand.id);
      },
      child: Card(
        color: brand.isSelected ? Colors.blue : Colors.yellow,
        child: Center(child: Text(brand.name, textAlign: TextAlign.center)),
      ),
    );
  }
}
