
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:partner/entity/ProfileEntity.dart';
import 'package:partner/entity/orderListEntity.dart';
import 'package:partner/entity/partnerInfoEntity.dart';
import 'package:partner/entity/pendingOrderInfo.dart';
import 'package:partner/entity/shopInfoEntity.dart';
import 'package:partner/models/mModel/modelItemBrand.dart';
import 'package:partner/models/mModel/modelItemCategory.dart';
import 'package:partner/models/mModel/modelItemSubCategory.dart';
import 'package:partner/values/Constants.dart';

import '../models/mModel/modelCategory.dart';
import '../models/mModel/modelService.dart';
import 'gqlQueries.dart';

final apiProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  IOClient _ioClient = IOClient();
  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    final HttpClient _httpClient = HttpClient();
    _httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    _ioClient = IOClient(_httpClient);
  }

  _getGLClient(String accessToken) {
    final HttpLink _httpLink = HttpLink(Constants.gqlURL,
        httpClient: _ioClient,
        defaultHeaders: {
          Constants.bearer: accessToken,
        });
    final AuthLink _authLink = AuthLink(
      getToken: () async => '${Constants.bearer} $accessToken',
    );
    final Link _link = _authLink.concat(_httpLink);
    return GraphQLClient(link: _link, cache: GraphQLCache());
  }

  // HttpApiCalls
  Future<http.Response> getOtpFor(String phoneNumber) async {
    final response = await http.post(Uri.parse(Constants.httpURL + 'send-otp'),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'phone': '+91' + phoneNumber,
        }));
    print('OTP' + response.statusCode.toString());
    return response;
  }

  Future<http.Response> getApId(String otp, String phoneNumber) async {
    final response = await http.post(
        Uri.parse(Constants.httpURL + 'partner-verify-otp'),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(
            <String, String>{'phone': '+91' + phoneNumber, 'otp': otp}));
    print('token -> ' + response.body);
    return response;
  }

  // GraphQlCalls
  _getQueryResult(String query, {QueryOptions? queryOptions}) async {
    try {
      String accessToken = await readAccessToken() ?? '';
      if (accessToken.isEmpty) {
        throw 'Access token not found';
      } else {
        try {
          QueryOptions options =
              queryOptions ?? QueryOptions(document: gql(query));
          GraphQLClient client = _getGLClient(accessToken);
          QueryResult result =
          await client.query(options).timeout(Duration(seconds: 10));
          if (result.hasException) {
            throw Exception(
                result.exception ?? 'GraphQL Query returned an exception');
          }
          return result;
        } catch (e) {
          rethrow;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  _getMutationResult(String query, {MutationOptions? mutationOptions}) async {
    try {
      String accessToken = await readAccessToken() ?? '';
        try {
          MutationOptions options = mutationOptions ??
              MutationOptions(
                document: gql(query),
              );
          GraphQLClient client = _getGLClient(accessToken);
          QueryResult result =
          await client.mutate(options).timeout(Duration(seconds: 10));
          if (result.hasException) {
            throw result.exception.toString();
          }
          return result;
        } catch (e) {
          rethrow;
        }

    } catch (e) {
      print(e);
    }
  }

  insertShopDetail(dynamic mModel) async {
    try {
      MutationOptions options =
      MutationOptions(document: gql(insertShopInfo), variables: {
        'name': mModel.shopName,
        'description': mModel.shopDesc,
        'avatar': mModel.shopPics,
        'approved_by_admin': mModel.approvedByAdmin,
        'enabled': mModel.shopEnabled,
      });
      final QueryResult result =
      await _getMutationResult(insertShopInfo, mutationOptions: options);
      return result.hasException;
    } catch (e) {
      rethrow;
    }
  }

  insertAddressDetail(dynamic mModel) async {
    try {
      MutationOptions options =
      MutationOptions(document: gql(query_inserShopAddress), variables: {
        'type': mModel.type,
        'house_no': mModel.houseNo,
        'apartment_road_area': mModel.street,
        'city': mModel.city,
        'landmark': mModel.landmark,
        'pincode': mModel.pincode,
        'latlng': mModel.latlng,
        'apartment_road_area': mModel.street
      });
      final QueryResult result = await _getMutationResult(
          query_inserShopAddress,
          mutationOptions: options);
      print('GQL DATA -> ' + result.data.toString());
      return result.data;
    } catch (e) {
      rethrow;
    }
  }

  updatePartner(PartnerInfoEntity partnerInfoModel) async {
    try {
      MutationOptions options = await MutationOptions(
          document: gql(query_updatePartnerInfo),
          variables: {
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
          });
      final result = await _getMutationResult(query_updatePartnerInfo,
          mutationOptions: options);
      print(result);
      return result.data;
    } catch (e) {
      print(e);
    }
  }

  getCurrentStep(String? partnerid) async {
    QueryOptions options = QueryOptions(
        document: gql(query_getCurrentStep),
        variables: {'partnerId': partnerid});

    final result =
    await _getQueryResult(query_getCurrentStep, queryOptions: options);

    if (result != null) {
      var content = result.data['namma_mechanics_partner'][0];
      dynamic partnerTableData = content['name'];
      List addressTableData = content['addresses'];
      List documentTableData = content['documents'];
      List shop = content['shops'];
      List shopCategory = [];
      List shopService = [];
      dynamic shopName = null;
      if (shop.isNotEmpty) {
        shopName = shop[0]['name'];
        shopCategory = content['shops'][0]['shop_brands'];
        shopService = content['shops'][0]['shop_services'];
        saveToken(shopId: content['shops'][0]['id']);
      }
      if (partnerTableData == null ||
          addressTableData.isEmpty ||
          documentTableData.isEmpty) {
        return 0;
      } else if (shopName == null) {
        return 1;
      } else if (shopCategory.isEmpty || shopService.isEmpty) {
        return 2;
      } else {
        return 3;
      }
    } else {
      return 0;
    }
  }

  insertShop(ShopEntity shop) async {
    try {
      MutationOptions options =
      MutationOptions(document: gql(insertShopInfo), variables: {
        "avatar": shop.avatarUrl,
        "desc": shop.shopDescription,
        "name": shop.shopName,
        "partnerID": shop.partnerId
      });

      var res =
      await _getMutationResult(insertShopInfo, mutationOptions: options);

      final shopId =
      await res.data['insert_namma_mechanics_shop']['returning'][0]['id'];

      if (shopId != null) {
        MutationOptions options =
        MutationOptions(document: gql(insertShopAddress), variables: {
          'street': shop.street,
          'houseNo': shop.shopNo,
          'city': shop.city,
          'latLng': shop.latlng,
          'pinCode': shop.pincode,
          'landMark': shop.landmark,
          'shopId': shopId,
        });
        var result = await _getMutationResult(insertShopAddress,
            mutationOptions: options);
        if (result != null) {
          String addressID = result.data['insert_namma_mechanics_address']
          ['returning'][0]['id'];
          if (addressID.isNotEmpty) {
            return ShopEntity(shopId: shopId);
          }
        }
        print('result-> ' + result.toString());
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  getCategoryList() async {
    dynamic result = await _getQueryResult(queryGetCategory);
    List<CategoryModel> mList = [];
    for (dynamic element in result!.data['namma_mechanics_item_category']) {
      mList.add(CategoryModel(
        name: element['name'],
        categoryID: element['id'],
        // todo should add others
      ));
    }
    print(result);
    return mList;
  }

  getSubCategory(List<String> categoryId) async {
    QueryOptions options = QueryOptions(
        document: gql(queryGetSubcategory), variables: {'list': categoryId});
    dynamic result =
    await _getQueryResult(queryGetSubcategory, queryOptions: options);

    List<ModelItemSubCategory> mModel = [];

    for (dynamic element in result.data['namma_mechanics_item_sub_category']) {
      mModel.add(ModelItemSubCategory(
          subCategoryId: element['id'],
          subCategoryName: element['name'],
          subCategoryIsSelected: false));
    }
    print("subCat -> " + mModel.toString());
    return mModel;
  }

  getBrands(List<String> subCategoryId) async {
    QueryOptions options = QueryOptions(
        document: gql(queryBrands), variables: {'list': subCategoryId});
    dynamic result = await _getQueryResult(queryBrands, queryOptions: options);
    List<String> brandIds = [];
    for (dynamic element
    in result.data['namma_mechanics_item_sub_category_brand']) {
      brandIds.add(element['brand_id']);
    }

    QueryOptions brandOptions = QueryOptions(
        document: gql(quertBrandList), variables: {'list': brandIds});
    dynamic brandResult =
    await _getQueryResult(quertBrandList, queryOptions: brandOptions);

    List<ModelItemBrand> brands = [];
    for (dynamic element in brandResult.data['namma_mechanics_brand']) {
      brands.add(ModelItemBrand(
          brandId: element['id'],
          brandName: element['name'],
          brandIsSelected: false));
    }
    return brands;
  }

  getAllCategory() async {
    try {
      var result = await _getQueryResult(queryGetAllCategory);
      List<dynamic> data = result.data['namma_mechanics_item_category'];
      List<ItemCategory> categories = [];
      data.forEach((element) {
        categories.add(ItemCategory.fromJson(element));
      });
      return categories;
    } catch (e) {
      print(e);
    }
  }

  getServiceList() async {
    var result = await _getQueryResult(queryServiceList);
    Map<String, ModelService> finalList = {};
    for (dynamic element in result.data['namma_mechanics_service']) {
      finalList[element['id']] = ModelService(element['name'], element['rate'],
          element['rate_configurable'], element['id'], false);
    }
    return finalList;
  }

  getOrderList() async {
    String? shopID = await readShopId();
    QueryOptions options = QueryOptions(document: gql(getPlacedOrdersList),
        variables: {'shopId': shopID});
    // await readShopId()
    var result =
    await _getQueryResult(getPlacedOrdersList, queryOptions: options);
    List<OrderListEntity> entities = [];

    for (dynamic element in result.data['namma_mechanics_order']) {
      entities.add(OrderListEntity(
          description: element['description'],
          orderId: element['id'],
          amount: element['amount'],
          placedOn: element['placed_on'],
          customerId: element['consumer_id']));
    }
    print(result.toString());
    return entities;
  }

  getPendingOrderInfo(String custId, String orderId) async {
    QueryOptions options = QueryOptions(
        document: gql(queryCustomerInfo),
        variables: {'custId': custId, 'orderId': orderId});

    final result =
    await _getQueryResult(queryCustomerInfo, queryOptions: options);

    if(result != null) {
      final cust_data = result.data['namma_mechanics_consumer'][0];
      final orderData = result.data['namma_mechanics_consumer'][0]['orders'];
      List<ModelService> orderService = [];

      for(var element in orderData[0]['order_services']) {
        orderService.add(ModelService(element['shop_service']['name'], element['shop_service']['amount'], false, null, false));
      }

      PendingOrderInfo entity = await PendingOrderInfo(
        custName: cust_data['name'],
        customerId: cust_data['id'],
        custProfile: cust_data['avatar'],
        orderDescription: orderData[0]['description'],
        serviceModel: orderService
      );
      print(result.toString());

      return entity;
    }
  }

  getActionRequiredOrders() async {
    QueryOptions options = QueryOptions(
        document: gql(queryGetActionRequired),
        variables: {'shopId': "7bdfde1a-0483-45ce-aa74-4459c60b611d"});
    final result =
    await _getQueryResult(queryGetActionRequired, queryOptions: options);

    List<OrderListEntity> mList = [];
    for (dynamic element in result.data['namma_mechanics_order']) {
      mList.add(OrderListEntity(
          customerId: element['consumer_id'],
          placedOn: element['placed_on'],
          amount: element['amount'],
          description: element['description'],
          orderId: element['id'],
          orderStatus: element['order_status_details'][0]['status']));
    }
    print(result);
    return mList;
  }

  getProfileInfo() async {
    QueryOptions options = QueryOptions(
        document: gql(queryGetProfileInfo),
        variables: {'partnerId': await readPartnerId()});

    QueryResult result =
    await _getQueryResult(queryGetProfileInfo, queryOptions: options);

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
    PartnerInfoEntity partnerInfoEntity = await PartnerInfoEntity(
        partnerName: partner['name'],
        partnerAddressId: partner['id'],
        partnerProfilePic: partner['avatar'],
        partnerFlatNo: partnerAddress['house_no'],
        partnerLandmark: partnerAddress['landmark'],
        partnerStreet: partnerAddress['apartment_road_area'],
        partnerCity: partnerAddress['city'],
        partnerPincode: partnerAddress['pincode']);

    ShopEntity shopEntity = await ShopEntity(
        shopName: shop['name'],
        shopDescription: shop['description'],
        shopNo: shop['addresses'][0]['house_no'],
        street: shop['addresses'][0]['apartment_road_area'],
        city: shop['addresses'][0]['city'],
        landmark: shop['addresses'][0]['landmark'],
        pincode: shop['addresses'][0]['pincode']);

    List<ModelService> serviceList = [];
    for (var element in services) {
      serviceList.add(
          ModelService(element['name'], element['amount'], false, null, false));
    }

    ProfileEntity profileEntity = ProfileEntity(
        partnerInfoEntity: partnerInfoEntity,
        reviews: reviewList,
        shopEntity: shopEntity,
        shopService: serviceList);

    print(result);
    return profileEntity;
  }

  changeOrderStatus(String orderId, String status) async {
    MutationOptions options = MutationOptions(
        document: gql(queryChangeOrderStatus),
        variables: {'status': status, 'orderId': orderId});

    var result = await _getMutationResult(queryChangeOrderStatus,
        mutationOptions: options);

    return result.data['update_namma_mechanics_order_status_details']
    ['returning'][0];
  }

  Future<List<String>> getStatusList() async {
    var result = await _getQueryResult(queryStatusList);
    List<String> statusList = [];
    for (var status in result.data['namma_mechanics_order_status']) {
      if (status['order_status'] != 'PLACED' &&
          status['order_status'] != 'REJECTED' &&
          status['order_status'] != 'ACCEPTED' &&
          status['order_status'] != 'CANCELED') {
        statusList.add(status['order_status']);
      }
    }
    return statusList;
  }

  insertSubCategory(var map) async {
    MutationOptions options = MutationOptions(
        document: gql(queryInsertSubCategory), variables: {'subCatList': map});

    var result = await _getMutationResult(queryInsertSubCategory,
        mutationOptions: options);
    return result;
  }

  insertBrand(List<Map<String, String>> map) async {
    MutationOptions options = MutationOptions(
        document: gql(queryInsertBrand), variables: {'brandList': map});

    var result =
    await _getMutationResult(queryInsertBrand, mutationOptions: options);
    print(result);
    return result;
  }

  updateProfile(ProfileEntity entity) async {
    MutationOptions options =
    MutationOptions(document: gql(queryUpdateProfile), variables: {
      "partnerId": await readPartnerId(),
      "partnerName": entity.partnerInfoEntity!.partnerName,
      "partnerStreet": entity.partnerInfoEntity!.partnerStreet,
      "partnerCity": entity.partnerInfoEntity!.partnerCity,
      "partnerHouseNo": entity.partnerInfoEntity!.partnerFlatNo,
      "partnerLandmark": entity.partnerInfoEntity!.partnerLandmark,
      "partnerLatlng": "0.0",
      "partnerPincode": entity.partnerInfoEntity!.partnerPincode,
      "shopId": await readShopId(),
      "shopName": entity.shopEntity!.shopName,
      "shopDescription": entity.shopEntity!.shopDescription,
      "shopStreet": entity.shopEntity!.street,
      "shopCity": entity.shopEntity!.city,
      "shopHouseNo": entity.shopEntity!.shopNo,
      "shopLandmark": entity.shopEntity!.landmark,
      "shopLatlng": "0.0",
      "shopPincode": entity.shopEntity!.pincode
    });
    var result =
    _getMutationResult(queryUpdateProfile, mutationOptions: options);

    return result;
  }

  insertService(List<ModelService> serviceList) async {
    List<Map<dynamic, dynamic>> mMap = [];

    for (var data in serviceList) {
      mMap.add(await data.toJson());
    }

    MutationOptions options = MutationOptions(
        document: gql(queryInsertService), variables: {'list': mMap});

    var result =
    await _getMutationResult(queryInsertService, mutationOptions: options);

    if (result != null) {
      return result.data['insert_namma_mechanics_shop_service']['id'];
    }
    print(result);
  }

  // Other_Methods
  void saveToken({String? token, String? partnerID, String? shopId}) async {
    if (token != null) {
      _storage.write(key: Constants.token, value: token);
    }
    if (partnerID != null) {
      _storage.write(key: Constants.partnerID, value: partnerID);
    }
    if (shopId != null) {
      _storage.write(key: Constants.shopID, value: shopId);
    }
  }

  Future<String?> readAccessToken() async {
    return await _storage.read(key: Constants.token);
  }

  Future<String?> readPartnerId() async {
    String? partnerID = await _storage.read(key: Constants.partnerID);
    return partnerID;
  }

  Future<String?> readShopId() async {
    return await _storage.read(key: Constants.shopID);
  }

  bool isAccessTokenExpired(String token) {
    if (token.isEmpty) {
      return true;
    } else {
      return JwtDecoder.isExpired(token);
    }
  }

  void logOut() async {
    await _storage.deleteAll();
  }
}
