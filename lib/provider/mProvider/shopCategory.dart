import 'package:partner/Screens/FormPage/form.dart';
import 'package:partner/Screens/FormPage/widgets/register_shop_services.dart';
import 'package:partner/models/mModel/nm_service.dart';
import 'package:partner/services/apiService.dart';
import 'package:riverpod/riverpod.dart';

enum UpdateShopCategoryStatus { initial, loading, success, failure }

class ShopCategoryState {
  UpdateShopCategoryStatus status;
  AsyncValue<ShopCategoryEntity>? data;
  String? error;

  ShopCategoryState(this.status, this.data, this.error);
}

class ShopCategoryEntity {
  String id;

  ShopCategoryEntity(this.id);
}

final shopCategoryNotifierProvider =
    StateNotifierProvider<ShopCategoryNotifier, ShopCategoryState?>((ref) {
  return ShopCategoryNotifier(ref);
});

class ShopCategoryNotifier extends StateNotifier<ShopCategoryState?> {
  Ref ref;

  ShopCategoryNotifier(this.ref)
      : super(ShopCategoryState(
            UpdateShopCategoryStatus.initial, AsyncLoading(), ""));

  insertShoptype(List<String>? categoryList, List<String> subCategoryList,
      List<String> brand, Map<String, ModelService> selectedServices) async {
    state = _loadingState();

    String? shopID = await ApiService().readShopId();
    List<Map<String, String>> map = [];
    for (var val in subCategoryList) {
      Map<String, String> tempMap = {};
      tempMap['shop_id'] = shopID!;
      tempMap['sub_category_id'] = val;
      map.add(tempMap);
    }

    var result = await ApiService().insertSubCategory(map);
    if (result != null) {
      List<Map<String, String>> map = [];
      for (var val in brand) {
        Map<String, String> tempMap = {};
        tempMap['shop_id'] = shopID!;
        tempMap['brand_id'] = val;
        map.add(tempMap);
      }
      var res = await ApiService().insertBrand(map);
      if (res != null) {
        print('cat & brand done');

        List<ModelService> serviceList = [];
        selectedServices.map((key, value) {
          serviceList.add(value);
          return MapEntry(key, value);
        });

        var serviceRes = await ApiService().insertService(serviceList);

        if (serviceRes != null) {
          state = _dataState(serviceRes);
          return serviceRes;
        }
      }
    }
  }

  setLoadingState() {
    state = _loadingState();
  }

  _loadingState() {
    return ShopCategoryState(
        UpdateShopCategoryStatus.loading, state!.data, state!.error);
  }

  _dataState(ShopCategoryEntity shopCategoryEntity) {
    return ShopCategoryState(UpdateShopCategoryStatus.success,
        AsyncData(shopCategoryEntity), state!.error);
  }
}
