import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/models/mModel/modelItemBrand.dart';
import 'package:partner/models/mModel/nm_category.dart';
import 'package:partner/models/mModel/nm_sub_category.dart';
import 'package:partner/services/apiService.dart';

import '../../models/mModel/modelCategory.dart';
import '../../models/mModel/nm_service.dart';

final getAllCategoryNotifierProvider = StateNotifierProvider<GetAllCategoryNotifier, List<ItemCategory>>((ref){
  return GetAllCategoryNotifier(ref);
});

class GetAllCategoryNotifier extends StateNotifier<List<ItemCategory>> {
  Ref ref;

  GetAllCategoryNotifier(this.ref) : super([]);

  getAllCategory() async {
    state = await ApiService().getAllCategory();
  }

  selectCategory(String id) {
    state = state.map((e) {
      if(e.id==id){
        e.isSelected = !e.isSelected;
      }
      return e;
    }).toList();
  }

  selectSubCategory(String id) {
    state = state.map((e) {
      if(e.isSelected){
        e.itemSubCategories = e.itemSubCategories.map((j) {
          if(j.id==id){
            j.isSelected = !j.isSelected;
            if(j.isSelected) {
              ref.read(selectedSubCategoryStateProvider.notifier).add(
                  ModelSelectedSubCategory(j.name, j.id));
            } else {
              ref.read(selectedSubCategoryStateProvider.notifier).remove(
                  ModelSelectedSubCategory(j.name, j.id));
            }

          }
          return j;
        }).toList();
      }
      return e;
    }).toList();
  }

  void selectBrand(id) {
    state = state.map((e) {
      if(e.isSelected){
        e.itemSubCategories = e.itemSubCategories.map((j) {
          if(j.isSelected){
            j.itemSubCategoryBrands = j.itemSubCategoryBrands.map((k) {
              if(k.brand!.id == id) {
                k.brand!.isSelected = !k.brand!.isSelected;
              }
              return k;
            }).toList();
          }
          return j;
        }).toList();
      }
      return e;
    }).toList();

  }
}

//sub category
final selectedSubCategoryStateProvider = StateNotifierProvider<SelectedSubCategoryNotifier, List<ModelSelectedSubCategory>>((ref) => SelectedSubCategoryNotifier(ref));


class SelectedSubCategoryNotifier extends StateNotifier<List<ModelSelectedSubCategory>> {
  Ref ref;

  SelectedSubCategoryNotifier(this.ref) : super([]);

  add(ModelSelectedSubCategory data) {
    state.add(data);
  }

  remove(ModelSelectedSubCategory data) {
    state.removeWhere((element) => element.name == data.name);
  }

}