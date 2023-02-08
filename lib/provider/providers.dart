import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/data/app_repository.dart';
import 'package:partner/models/mModel/modelCategory.dart';
import 'package:partner/models/mModel/modelItemCategory.dart';
import 'package:partner/models/mModel/modelItemSubCategory.dart';
import 'package:partner/models/mModel/modelService.dart';
import 'package:tuple/tuple.dart';

final registrationStatusProvider = FutureProvider<int?>((ref) async {
  return await ref
      .read(appRepositoryProvider)
      .getCurrentStep(FirebaseAuth.instance.currentUser?.uid);
});

final serviceListProvider = FutureProvider<List<NMService>>((ref) async {
  return await ref.read(appRepositoryProvider).getServices();
});

final categoryListProvider = FutureProvider<List<NMCategory>>((ref) async {
  return await ref.read(appRepositoryProvider).getCategoryList();
});

final multiSubCategoryListProvider =
    FutureProvider.family<List<SubCategory>, String>((ref, args) async {
  List<String> categoryIds = args.split('#');
  if (categoryIds.isEmpty) {
    return [];
  }
  List<SubCategory> subCategories = [];
  categoryIds.forEach((element) async {
    subCategories.addAll(await ref.read(subCategoryListProvider(element).future));
  });
  return subCategories;
});

final subCategoryListProvider = FutureProvider.family<List<SubCategory>, String>((ref, args) async {
  return await ref.read(appRepositoryProvider).getSubCategory(categoryId: args);
});

final multiBrandListProvider = FutureProvider.family<List<Brand>, String>((ref, args) async {
  List<String> subCategoryIds = args.split('#');
  if (subCategoryIds.isEmpty) {
    return [];
  }
  List<Brand> brands = [];
  subCategoryIds.forEach((element) async {
    brands.addAll(await ref.read(brandListProvider(element).future));
  });
  return brands;
});

final brandListProvider = FutureProvider.family<List<Brand>, String>((ref, args) async {
  return await ref.read(appRepositoryProvider).getBrands(subCategoryId: args);
});

