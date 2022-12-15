import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/mModel/modelCategory.dart';
import '../../../provider/mProvider/selectionProvider.dart';
import '../../../values/MyTextstyle.dart';

class ShopCategory extends ConsumerStatefulWidget {
  const ShopCategory({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopCategory> createState() => _ShopCategoryState();
}

class _ShopCategoryState extends ConsumerState<ShopCategory> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref.read(getAllCategoryNotifierProvider.notifier).getAllCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Consumer(builder: (context, ref, child) {
          List<ItemCategory> categoryList =
              ref.watch(getAllCategoryNotifierProvider);
          List<ItemSubCategories> subCategoryList = [];
          List<Brand> brandList = [];
          for (var element in categoryList) {
            if (element.isSelected) {
              for (var items in element.itemSubCategories) {
                subCategoryList.add(items);
                if (items.isSelected) {
                  for (var brand in items.itemSubCategoryBrands) {
                    brandList.add(brand.brand!);
                  }
                }
              }
            }
          }
          return Column(
            children: [
              GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisExtent: 80),
                  itemCount: categoryList.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return getCategoryItem(index, categoryList, 0);
                  }),
              subCategoryList.isEmpty
                  ? Container()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Sub Category",
                                style: MyTextStyle.formSubHeading,
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, mainAxisExtent: 80),
                            itemCount: subCategoryList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return getSubCategoryItem(
                                  index, subCategoryList, 1);
                            }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Brand",
                                style: MyTextStyle.formSubHeading,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              brandList.isEmpty
                  ? Container()
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, mainAxisExtent: 80),
                      itemCount: brandList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return getBrandItem(index, brandList, 2);
                      }),
            ],
          );
        }),
      ],
    );
  }

  getCategoryItem(int index, var list, int type) {
    ItemCategory item = list[index];
    return GestureDetector(
      onTap: () {
        ref
            .read(getAllCategoryNotifierProvider.notifier)
            .selectCategory(list[index].id);
      },
      child: Card(
        color: item.isSelected ? Colors.blue : Colors.yellow,
        child: Center(child: Text(item.name, textAlign: TextAlign.center)),
      ),
    );
  }

  getSubCategoryItem(
      int index, List<ItemSubCategories> subCategoryList, int i) {
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
