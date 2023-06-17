import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/data/app_repository.dart';
import 'package:partner/entity/orderListEntity.dart';
import 'package:partner/entity/partnerInfoEntity.dart';
import 'package:partner/models/mModel/nm_category.dart';
import 'package:partner/models/mModel/nm_sub_category.dart';
import 'package:partner/models/mModel/nm_service.dart';

final registrationStatusProvider = FutureProvider<int?>((ref) async {
  return await ref.read(appRepositoryProvider).getCurrentStep(FirebaseAuth.instance.currentUser?.uid);
});

final shopIdProvider = FutureProvider<String?>((ref) async {
  return await ref.read(appRepositoryProvider).getShopId(FirebaseAuth.instance.currentUser?.uid);
});

final ordersProvider = FutureProvider.family<List<WorkOrder>, String>((ref, shopId) async {
  return await ref.read(appRepositoryProvider).getOrders(shopId: shopId);
});

final actionRequiredOrdersProvider = FutureProvider.family<List<WorkOrder>?, String>((ref, shopId) async {
  return await ref.read(appRepositoryProvider).getActionRequiredOrders(shopId: shopId);
});

final categoriesProvider = FutureProvider<List<NMCategory>>((ref) async {
  return await ref.read(appRepositoryProvider).getCategoryList();
});

final subCategoriesProvider = FutureProvider.family<List<NMSubCategory>, SubCategoryProviderParam>((ref, args) async {
  return await ref.read(appRepositoryProvider).getSubCategories(categoryIds: args.toIds());
});

final servicesProvider = FutureProvider.family<List<NMService>, ServicesProviderParam>((ref, args) async {
  return await ref.read(appRepositoryProvider).getServices(subCategoryIds: args.toIds());
});

final partnerInfoProvider = FutureProvider.family<PartnerInfoEntity, String>((ref, args) async {
  return await ref.read(appRepositoryProvider).getPartnerInfo(partnerId: args);
});

class SubCategoryProviderParam extends Equatable {
  final List<NMCategory> categories;

  const SubCategoryProviderParam(this.categories);

  @override
  List<Object?> get props => [categories];

  List<String> toIds() {
    categories.removeWhere((element) => element.categoryID == null);
    return categories.map((e) => e.categoryID!).toList();
  }
}

class ServicesProviderParam extends Equatable {
  final List<NMSubCategory> subCategories;

  const ServicesProviderParam(this.subCategories);

  @override
  List<Object?> get props => [subCategories];

  List<String> toIds() {
    subCategories.removeWhere((element) => element.subCategoryId == null);
    return subCategories.map((e) => e.subCategoryId!).toList();
  }
}
