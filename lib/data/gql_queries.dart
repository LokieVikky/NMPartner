class GQLQueries {
  static const String query_insertShopDetail = r''' 
mutation mutationInsertShop($approved_by_admin: Boolean = false, $avatar: String = "", $description: String = "", $enabled: Boolean = false, $name: String = "") {
  insert_namma_mechanics_shop(objects: {approved_by_admin: $approved_by_admin, avatar: $avatar, description: $description, enabled: $enabled, name: $name}) {
  returning {
  name
    }
  }
}
''';

  static const String query_inserShopAddress = r''' 
mutation mutationInsertShop($apartment_road_area: String = "", $city: String = "", $house_no: String = "", $landmark: String = "", $latlng: String = "", $pincode: String = "", $type:String = "") {
  insert_namma_mechanics_address(objects: {apartment_road_area: $apartment_road_area, city: $city, house_no: $house_no, landmark: $landmark, latlng: $latlng, pincode: $pincode, type: $type}) {
  returning {
    apartment_road_area
    }
  }
}
''';

  static const String queryGetPartnerInfo = r''' 
  query MyQuery($_eq: String = "") {
  namma_mechanics_partner(where: {id: {_eq: $_eq}}) {
    id
    avatar
    name
    phone
    addresses {
      id
      house_no
      apartment_road_area
      city
      pincode
      landmark
    }
    documents {
      document_number
      document_type
      photo_back
      photo_front
    }
  }
}

  ''';

  static const String query_updatePartnerInfo = r'''
mutation MyMutation($userId: String = "", $name: String = "", $avatar: String = "",
$house_no: String = "", $apartment_road_area: String = "", $city: String = "", $pincode: String = "", $landmark: String = "", $latlng: String = "",
$aadhaar_document_number: String = "", $aadhaar_document_type: String = "", $aadhaar_photo_back: String = "", $aadhaar_photo_front: String = "",
$pan_document_number: String = "", $pan_document_type: String = "", $pan_photo_back: String = "", $pan_photo_front: String = "") {
  update_namma_mechanics_partner(where: {id: {_eq: $userId}}, _set: {name: $name, avatar: $avatar}) {
    returning {
      name
      avatar
    }
  }
  insert_namma_mechanics_address(objects: {house_no: $house_no, apartment_road_area: $apartment_road_area, city: $city, pincode: $pincode, landmark: $landmark, latlng: $latlng, partner_id: $userId}) {
    returning {
      id
    }
  }
  insert_namma_mechanics_document(objects:[ {document_number: $aadhaar_document_number, document_type: $aadhaar_document_type, partner_id: $userId, photo_back: $aadhaar_photo_back, photo_front: $aadhaar_photo_front}, 
   {document_number: $pan_document_number, document_type: $pan_document_type, partner_id: $userId, photo_back: $pan_photo_back, photo_front: $pan_photo_front}]) {
    returning {
      partner_id
    }
  }
}
''';

  static const String query_getCurrentStep = r'''
query MyQuery($partnerId: String!) {
  namma_mechanics_partner(where: {id: {_eq: $partnerId}}) {
    name
    shops {
      name
      shop_brands {
        shop_id
      }
      shop_services {
        name
      }
      id
    }
    addresses {
      city
      id
    }
    documents {
      document_type
    }
  }
}
''';

  static const String queryGetCategory = r'''
query MyQuery {
  namma_mechanics_item_category {
    description
    enabled
    icon
    id
    is_highlighted
    name
  }
}
''';

  static const String queryGetSubcategory = r'''
query MyQuery($_eq: uuid = "") {
  namma_mechanics_item_sub_category(where: {category_id: {_eq: $_eq}}) {
    category_id
    name
    description
    enabled
    icon
    id
  }
}

''';

  static const String querySubCategories = r''' 
  query MyQuery($_in: [uuid!] = "") {
  namma_mechanics_item_sub_category(where: {category_id: {_in: $_in}}) {
    id
    name
    icon
    description
    enabled
    category_id
  }
}
  ''';

  static const String queryBrands = r'''
query MyQuery($_eq: uuid = "") {
  namma_mechanics_item_sub_category_brand(where: {sub_category_id: {_eq: $_eq}}) {
    brand {
      name
      id
    }
  }
}
''';

  static const String quertBrandList = r'''
query MyQuery($list: [uuid!]) {
  namma_mechanics_brand(where: {id: {_in: $list}}) {
    icon
    enabled
    id
    description
    name
  }
}

''';

  static const String queryGetAllCategory = r'''
query MyQuery {
  namma_mechanics_item_category {
    id
    name
    item_sub_categories {
      id
      name
      category_id
      item_sub_category_brands {
        brand {
          name
          id
        }
      }
    }
  }
}
''';

  static const String queryServiceList = r'''
query MyQuery {
  namma_mechanics_service {
    id
    name
    rate
    rate_configurable
    description
    sub_category_id
  }
}    
''';

  static const String queryServiceListForSubCategory = r'''
query MyQuery($_in: [uuid!] = "") {
  namma_mechanics_service(where: {sub_category_id: {_in: $_in}}) {
    id
    name
    rate
    rate_configurable
    description
    sub_category_id
  }
}
''';

  static const String insertShopInfo = r'''
mutation MyMutation($avatar: String = "", $desc: String = "", $name: String = "", $partnerID: String = "") {
  insert_namma_mechanics_shop(objects: {avatar: $avatar, description: $desc, name: $name, enabled: true, partner_id: $partnerID}) {
    returning {
      id
    }
  }
}
''';

  static const String insertShopAddress = r'''
mutation MyMutation($street : String = "", $city : String = "", $houseNo : String = "", $latLng : String = "", $pinCode : String = "", $shopId : uuid = "", $landMark : String!) {
  insert_namma_mechanics_address(objects: {apartment_road_area: $street, city: $city, house_no: $houseNo, latlng: $latLng, landmark: $landMark, pincode: $pinCode, shop_id: $shopId}) {
    returning {
      id
    }
  }
}
''';
  static const String getPlacedOrdersList = r'''
query MyQuery($shopId : uuid = "") {
  namma_mechanics_order(where: {shop_id: {_eq: $shopId}, 
  _and: {order_status_details: {order_status: {order_status: {_eq: "PLACED"}}}}}) {
    amount
    description
    id
    latest_update_on
    placed_on
    remarks
    shop_id
    consumer_id
  }
}
''';

  static const String queryOrderList = r'''
query MyQuery($shopId : uuid = "") {
  namma_mechanics_order(where: {shop_id: {_eq: $shopId}}) {
    amount
    consumer_id
    description
    id
    latest_update_on
    pickup
    pickup_drop_details_id
    placed_on
    remarks
    shop_id
  }
}
''';

  static const String queryCustomerInfo = r'''
query MyQuery($custId: uuid!, $orderId: uuid!) {
  namma_mechanics_consumer(where: {id: {_eq: $custId}}) {
    avatar
    dob
    gender
    email
    id
    name
    phone
    orders(where: {id: {_eq: $orderId}}) {
      description
      order_services {
        shop_service {
          id
          amount
          rate
          service_id
          shop_id
          tax
          name
        }
      }
    }
  }
}
''';

  static const String queryGetActionRequired = r'''
query MyQuery($shopId: uuid = "") {
  namma_mechanics_order(where: {shop_id: {_eq: $shopId}, _and: {order_status_details: {order_status: {order_status: {_neq: "PLACED"}, _and: {order_status: {_neq: "REJECTED"}, _and: {order_status: {_neq: "CANCELED"}, _and: {order_status: {_neq: "COMPLETED"}}}}}}}}) {
    amount
    description
    id
    latest_update_on
    placed_on
    remarks
    shop_id
    consumer_id
    order_status_details {
      status
    }
  }
}
''';

  static const String queryGetProfileInfo = r'''
query MyQuery($partnerId: uuid!) {
  namma_mechanics_partner(where: {id: {_eq: $partnerId}}) {
    avatar
    id
    name
    phone
    shops {
      name
      description
      reviews {
        review
        rating
        consumer {
          name
        }
      }
      addresses {
        apartment_road_area
        city
        house_no
        landmark
        pincode
        shop_id
      }
      shop_services {
        name
        amount
      }
    }
    addresses {
      house_no
      id
      landmark
      pincode
      apartment_road_area
      city
    }
  }
}
''';

  static const String queryChangeOrderStatus = r'''
mutation MyMutation($status : String!, $orderId : uuid!) {
  update_namma_mechanics_order_status_details(_set: {status: $status}, where: {order_id: {_eq: $orderId}}) {
    returning {
      order_id
      status
    }
  }
}
''';

  static const String queryStatusList = r'''
query MyQuery {
  namma_mechanics_order_status {
    order_status
  }
}
''';

  static const String queryInsertSubCategory = r'''
mutation MyMutation($subCatList: [namma_mechanics_item_sub_category_shop_insert_input!]!) {
  insert_namma_mechanics_item_sub_category_shop(objects: $subCatList) {
    returning {
      id
    }
  }
}
''';

  static const String queryInsertBrand = r'''
mutation MyMutation($brandList: [namma_mechanics_shop_brand_insert_input!]!) {
  insert_namma_mechanics_shop_brand(objects: $brandList) {
    returning {
      id
    }
  }
}
''';

  static const String queryUpdateProfile = r'''
mutationMyMutation($partnerId: uuid!,
$partnerName: String!,
$partnerStreet: String!,
$partnerCity: String!,
$partnerHouseNo: String!,
$partnerLandmark: String!,
$partnerLatlng: String!,
$partnerPincode: String!,
$shopId: uuid!,
$shopName: String!,
$shopDescription: String!,
$shopStreet: String!,
$shopCity: String!,
$shopHouseNo: String!,
$shopLandmark: String!,
$shopLatlng: String!,
$shopPincode: String!,
){
  item1: update_namma_mechanics_partner(where: {
    id: {
      _eq: $partnerId
    }
  },
  _set: {
    name: $partnerName
  }){
    returning{
      id
    }
  }item2: update_namma_mechanics_address(where: {
    partner_id: {
      _eq: $partnerId
    }
  },
  _set: {
    apartment_road_area: $partnerStreet,
    city: $partnerCity,
    house_no: $partnerHouseNo,
    landmark: $partnerLandmark,
    latlng: $partnerLatlng,
    pincode: $partnerPincode
  }){
    returning{
      id
    }
  }update_namma_mechanics_address(where: {
    shop_id: {
      _eq: $shopId
    }
  },
  _set: {
    apartment_road_area: $shopStreet,
    city: $shopCity,
    house_no: $shopHouseNo,
    landmark: $shopLandmark,
    latlng: $shopLatlng,
    pincode: $shopPincode
  }){
    returning{
      id
    }
  }update_namma_mechanics_shop(where: {
    id: {
      _eq: $shopId
    }
  },
  _set: {
    description: $shopDescription,
    name: $shopName
  }){
    returning{
      id
    }
  }
}
''';

  static const String queryInsertService = r'''
mutation MyMutation($list :[namma_mechanics_shop_service_insert_input!]!) {
  insert_namma_mechanics_shop_service(objects: $list) {
    returning {
      id
    }
  }
}
''';
}
