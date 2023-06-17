import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:partner/data/gql_queries.dart';
import 'package:partner/entity/orderListEntity.dart';
import 'package:partner/entity/partnerInfoEntity.dart';
import 'package:partner/entity/pendingOrderInfo.dart';
import 'package:partner/entity/shopInfoEntity.dart';
import 'package:partner/models/mModel/modelCategory.dart';
import 'package:partner/models/mModel/nm_category.dart';
import 'package:partner/models/mModel/nm_sub_category.dart';
import 'package:partner/models/mModel/nm_service.dart';
import 'package:partner/providers.dart';
import 'package:partner/shared/graphql_client.dart';

import '../entity/ProfileEntity.dart';

final appRepositoryProvider = Provider<AppRepository>((ref) {
  return AppRepository(ref);
});

class AppRepository {
  late AppGraphQLClient _appGraphQLClient;
  late FirebaseAuth _firebaseAuth;

  AppRepository(ProviderRef<AppRepository> ref) {
    _appGraphQLClient = ref.read(graphQLProvider);
    _firebaseAuth = ref.read(firebaseAuthProvider);
  }

  Future<bool> insertShopDetail(dynamic mModel) async {
    try {
      final QueryResult result = await _appGraphQLClient.mutate(query: GQLQueries.insertShopInfo, variables: {
        'name': mModel.shopName,
        'description': mModel.shopDesc,
        'avatar': mModel.shopPics,
        'approved_by_admin': mModel.approvedByAdmin,
        'enabled': mModel.shopEnabled,
      });
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      if (result.data != null) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> insertAddressDetail(dynamic mModel) async {
    try {
      final QueryResult result = await _appGraphQLClient.mutate(query: GQLQueries.query_inserShopAddress, variables: {
        'type': mModel.type,
        'house_no': mModel.houseNo,
        'apartment_road_area': mModel.street,
        'city': mModel.city,
        'landmark': mModel.landmark,
        'pincode': mModel.pincode,
        'latlng': mModel.latlng,
        'apartment_road_area': mModel.street
      });
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      if (result.data != null) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<PartnerInfoEntity> getPartnerInfo({required String partnerId}) async {
    try {
      QueryResult result = await _appGraphQLClient.query(query: GQLQueries.queryGetCategory);
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      if (result.data == null) {
        throw Exception('Unable to load categories');
      }
      return (result.data?['namma_mechanics_item_category']?[0]).map((e) => PartnerInfoEntity.fromJson(e));
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updatePartner(PartnerInfoEntity partnerInfoModel) async {
    try {
      Map<String, dynamic> variables = {
        'userId': partnerInfoModel.partnerID,
        'name': partnerInfoModel.partnerName,
        'avatar': partnerInfoModel.partnerProfilePic,
        'house_no': partnerInfoModel.partnerFlatNo,
        'apartment_road_area': partnerInfoModel.partnerStreet,
        'city': partnerInfoModel.partnerCity,
        'pincode': partnerInfoModel.partnerPincode,
        'landmark': partnerInfoModel.partnerLandmark,
        'latlng': partnerInfoModel.partnerLatlng,
        'aadhaar_document_number': partnerInfoModel.partnerAadhaarNo,
        'aadhaar_document_type': "AADHAR",
        'aadhaar_photo_back': partnerInfoModel.partnerAadhaarBack,
        'aadhaar_photo_front': partnerInfoModel.partnerAadhaarFront,
        'pan_document_number': partnerInfoModel.partnerPanNo,
        'pan_document_type': "PAN",
        'pan_photo_back': partnerInfoModel.partnerPanBack,
        'pan_photo_front': partnerInfoModel.partnerPanFront,
      };
      final QueryResult result =
          await _appGraphQLClient.mutate(query: GQLQueries.query_updatePartnerInfo, variables: variables);
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      if (result.data != null) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateShop(ShopEntity shopEntity) async {
    try {
      Map<String, dynamic> variables = {
        "avatar": shopEntity.avatarUrl,
        "desc": shopEntity.shopDescription,
        "name": shopEntity.shopName,
        "partnerID": shopEntity.partnerId
      };

      final QueryResult result = await _appGraphQLClient.mutate(query: GQLQueries.insertShopInfo, variables: variables);
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      if (result.data != null) {
        final shopId = await result.data!['insert_namma_mechanics_shop']['returning'][0]['id'];
        Map<String, dynamic> variables = {
          'street': shopEntity.street,
          'houseNo': shopEntity.shopNo,
          'city': shopEntity.city,
          'latLng': shopEntity.latlng,
          'pinCode': shopEntity.pincode,
          'landMark': shopEntity.landmark,
          'shopId': shopId,
        };
        final QueryResult result2 =
            await _appGraphQLClient.mutate(query: GQLQueries.insertShopAddress, variables: variables);
        if (result2.hasException) {
          throw Exception(result2.exception.toString());
        }
        return shopId;
      }
      throw Exception('Something went wrong');
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getShopId(String? partnerId) async {
    try {
      final result =
          await _appGraphQLClient.query(query: GQLQueries.query_getCurrentStep, variables: {'partnerId': partnerId});
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      if (result.data == null) {
        throw Exception('Partner not found');
      }
      var content = result.data!['namma_mechanics_partner'][0];
      List shop = content['shops'];
      if (shop.isNotEmpty) {
        return shop[0]['id'];
      }
      throw Exception('Unable to find the respective shop');
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> getCurrentStep(String? partnerId) async {
    try {
      final result =
          await _appGraphQLClient.query(query: GQLQueries.query_getCurrentStep, variables: {'partnerId': partnerId});
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      if (result.data == null) {
        throw Exception('Partner not found');
      }
      var content = result.data!['namma_mechanics_partner'][0];
      dynamic partnerTableData = content['name'];
      List addressTableData = content['addresses'];
      List documentTableData = content['documents'];
      List shop = content['shops'];
      List shopCategory = [];
      List shopService = [];
      dynamic shopName;
      if (shop.isNotEmpty) {
        shopName = shop[0]['name'];
        shopCategory = content['shops'][0]['shop_brands'];
        shopService = content['shops'][0]['shop_services'];
        //saveToken(shopId: content['shops'][0]['id']);
      }
      if (partnerTableData == null || addressTableData.isEmpty || documentTableData.isEmpty) {
        return 0;
      } else if (shopName == null) {
        return 1;
        // } else if (shopCategory.isEmpty || shopService.isEmpty) {
      } else if (shopService.isEmpty) {
        return 2;
      } else {
        return 3;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> insertShop(ShopEntity shop) async {
    try {
      QueryResult result = await _appGraphQLClient.mutate(query: GQLQueries.insertShopInfo, variables: {
        "avatar": shop.avatarUrl,
        "desc": shop.shopDescription,
        "name": shop.shopName,
        "partnerID": shop.partnerId
      });

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      if (result.data == null) {
        throw Exception('Failed to create shop');
      }

      final shopID = result.data!['insert_namma_mechanics_shop']['returning'][0]['id'];

      if (shopID == null) {
        throw Exception('Failed to create shop');
      }

      return insertShopAddress(shop: shop, shopId: shopID);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> insertShopAddress({required ShopEntity shop, required shopId}) async {
    QueryResult result = await _appGraphQLClient.mutate(query: GQLQueries.insertShopAddress, variables: {
      'street': shop.street,
      'houseNo': shop.shopNo,
      'city': shop.city,
      'latLng': shop.latlng,
      'pinCode': shop.pincode,
      'landMark': shop.landmark,
      'shopId': shopId,
    });
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data != null) {
      return true;
    }
    return false;
  }

  Future<List<NMCategory>> getCategoryList() async {
    try {
      QueryResult result = await _appGraphQLClient.query(query: GQLQueries.queryGetCategory);
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      if (result.data == null) {
        throw Exception('Unable to load categories');
      }
      return (result.data?['namma_mechanics_item_category'] as List).map((e) => NMCategory.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<NMSubCategory>> getSubCategory({required String categoryId}) async {
    QueryResult result =
        await _appGraphQLClient.query(query: GQLQueries.queryGetSubcategory, variables: {'_eq': categoryId});
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data == null) {
      throw Exception('Unable to load sub categories');
    }
    return (result.data?['namma_mechanics_item_sub_category'] as List).map((e) => NMSubCategory.fromJson(e)).toList();
  }

  Future<List<NMSubCategory>> getSubCategories({required List<String> categoryIds}) async {
    QueryResult result =
        await _appGraphQLClient.query(query: GQLQueries.querySubCategories, variables: {'_in': categoryIds});
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data == null) {
      throw Exception('Unable to load sub categories');
    }
    return (result.data?['namma_mechanics_item_sub_category'] as List).map((e) => NMSubCategory.fromJson(e)).toList();
  }

  Future<List<Brand>> getBrands({required String subCategoryId}) async {
    print(subCategoryId);
    QueryResult result =
        await _appGraphQLClient.query(query: GQLQueries.queryBrands, variables: {'_eq': subCategoryId});
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data == null) {
      throw Exception('Unable to load brands');
    }
    return (result.data?['namma_mechanics_item_sub_category_brand'] as List).map((e) => Brand.fromJson(e)).toList();
  }

  Future<List<NMService>> getServices({List<String>? subCategoryIds}) async {
    QueryResult result;
    if (subCategoryIds == null) {
      result = await _appGraphQLClient.query(
        query: GQLQueries.queryServiceList,
      );
    } else {
      result = await _appGraphQLClient
          .query(query: GQLQueries.queryServiceListForSubCategory, variables: {'_in': subCategoryIds});
    }
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data == null) {
      throw Exception('Unable to load services');
    }
    return (result.data?['namma_mechanics_service'] as List).map((e) => NMService.fromJson(e)).toList();
  }

  Future<List<WorkOrder>> getOrders({required String shopId}) async {
    QueryResult result = await _appGraphQLClient.query(query: GQLQueries.queryOrderList, variables: {'shopId': shopId});
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data == null) {
      throw Exception('Unable to load orders');
    }
    return (result.data?['namma_mechanics_order'] as List).map((e) => WorkOrder.fromJson(e)).toList();
  }

  Future<PendingOrderInfo> getPendingOrderInfo({required String customerId, required String orderId}) async {
    QueryResult result = await _appGraphQLClient
        .query(query: GQLQueries.queryCustomerInfo, variables: {'custId': customerId, 'orderId': orderId});
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data == null) {
      throw Exception('Unable to pending orders');
    }

    final customerData = result.data?['namma_mechanics_consumer'][0];
    final orderData = result.data?['namma_mechanics_consumer'][0]['orders'];
    List<ModelService> orderService = [];

    return PendingOrderInfo(
        custName: customerData['name'],
        customerId: customerData['id'],
        custProfile: customerData['avatar'],
        orderDescription: orderData[0]['description'],
        serviceModel: orderService);
  }

  Future<List<WorkOrder>> getActionRequiredOrders({required String shopId}) async {
    QueryResult result =
        await _appGraphQLClient.query(query: GQLQueries.queryGetActionRequired, variables: {'shopId': shopId});
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data == null) {
      throw Exception('Unable to load orders');
    }
    return (result.data?['namma_mechanics_order'] as List).map((e) => WorkOrder.fromJson(e)).toList();
  }

  Future<ProfileEntity> getProfileInfo() async {
    QueryResult result = await _appGraphQLClient
        .query(query: GQLQueries.queryGetProfileInfo, variables: {'partnerId': _firebaseAuth.currentUser?.uid});
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data == null) {
      throw Exception('Unable to profile');
    }

    final partner = await result.data!['namma_mechanics_partner'][0];
    final shop = await partner['shops'][0];
    final reviews = await shop['reviews'];
    final partnerAddress = await partner['addresses'][0];
    final services = await shop['shop_services'];

    List<ReviewEntity> reviewList = [];
    for (dynamic review in reviews) {
      reviewList.add(ReviewEntity(
          reviewBy: review['consumer']['name'],
          reviewContent: review['review'],
          reviewDate: "",
          reviewRating: review["rating"]));
    }
    PartnerInfoEntity partnerInfoEntity = PartnerInfoEntity(
        partnerName: partner['name'],
        partnerAddressId: partner['id'],
        partnerProfilePic: partner['avatar'],
        partnerFlatNo: partnerAddress['house_no'],
        partnerLandmark: partnerAddress['landmark'],
        partnerStreet: partnerAddress['apartment_road_area'],
        partnerCity: partnerAddress['city'],
        partnerPincode: partnerAddress['pincode']);

    ShopEntity shopEntity = ShopEntity(
        shopName: shop['name'],
        shopDescription: shop['description'],
        shopNo: shop['addresses'][0]['house_no'],
        street: shop['addresses'][0]['apartment_road_area'],
        city: shop['addresses'][0]['city'],
        landmark: shop['addresses'][0]['landmark'],
        pincode: shop['addresses'][0]['pincode']);

    List<NMService> serviceList = [];
    for (var element in services) {
      serviceList.add(NMService.fromJson(element));
    }

    ProfileEntity profileEntity = ProfileEntity(
        partnerInfoEntity: partnerInfoEntity, reviews: reviewList, shopEntity: shopEntity, shopService: serviceList);

    return profileEntity;
  }

  Future<bool> changeOrderStatus(String orderId, String status) async {
    QueryResult result = await _appGraphQLClient
        .mutate(query: GQLQueries.queryChangeOrderStatus, variables: {'status': status, 'orderId': orderId});
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data != null) {
      return true;
    }
    return false;
  }

  Future<List<String>> getStatusList() async {
    QueryResult result = await _appGraphQLClient.mutate(query: GQLQueries.queryStatusList);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data == null) {
      throw Exception('Unable to status');
    }
    return (result.data?['namma_mechanics_order_status'] as List).map((e) => e.toString()).toList();
  }

//
  Future<bool> insertBrand(List<Map<String, String>> map) async {
    QueryResult result =
        await _appGraphQLClient.mutate(query: GQLQueries.queryInsertBrand, variables: {'brandList': map});
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data != null) {
      return true;
    }
    return false;
  }

//
// updateProfile(ProfileEntity entity) async {
//
//     queryUpdateProfile
//   MutationOptions options = MutationOptions(document: gql(queryUpdateProfile), variables: {
//     "partnerId": await readPartnerId(),
//     "partnerName": entity.partnerInfoEntity!.partnerName,
//     "partnerStreet": entity.partnerInfoEntity!.partnerStreet,
//     "partnerCity": entity.partnerInfoEntity!.partnerCity,
//     "partnerHouseNo": entity.partnerInfoEntity!.partnerFlatNo,
//     "partnerLandmark": entity.partnerInfoEntity!.partnerLandmark,
//     "partnerLatlng": "0.0",
//     "partnerPincode": entity.partnerInfoEntity!.partnerPincode,
//     "shopId": await readShopId(),
//     "shopName": entity.shopEntity!.shopName,
//     "shopDescription": entity.shopEntity!.shopDescription,
//     "shopStreet": entity.shopEntity!.street,
//     "shopCity": entity.shopEntity!.city,
//     "shopHouseNo": entity.shopEntity!.shopNo,
//     "shopLandmark": entity.shopEntity!.landmark,
//     "shopLatlng": "0.0",
//     "shopPincode": entity.shopEntity!.pincode
//   });
//   var result = _getMutationResult(queryUpdateProfile, mutationOptions: options);
//
//   return result;
// }
//

  Future<bool> insertService(String shopId, List<NMService> serviceList) async {
    QueryResult result = await _appGraphQLClient.mutate(query: GQLQueries.queryInsertService, variables: {
      'list': serviceList.map((e) {
        return {
          'service_id': e.id,
          'shop_id': shopId,
          'rate': e.rate,
          'tax': null,
          'amount': null,
          'name': e.name,
          'description': null,
          'sub_category_id': e.subCategoryId,
        };
      }).toList()
    });
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data != null) {
      return true;
    }
    return false;
  }
}
