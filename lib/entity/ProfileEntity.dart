import 'package:partner/entity/partnerInfoEntity.dart';
import 'package:partner/entity/shopInfoEntity.dart';

import '../models/mModel/nm_service.dart';

class ProfileEntity {
  List<ReviewEntity>? reviews;
  ShopEntity? shopEntity;
  List<NMService>? shopService;
  PartnerInfoEntity? partnerInfoEntity;

  ProfileEntity({this.reviews, this.shopEntity, this.shopService, this.partnerInfoEntity});

  ProfileEntity.fromJson(Map json){

  }
}

class ReviewEntity {
  String? reviewBy;
  String? reviewDate;
  String? reviewRating;
  String? reviewContent;

  ReviewEntity(
      {this.reviewBy, this.reviewDate, this.reviewRating, this.reviewContent});

  ReviewEntity.fromJson(Map json){
    reviewBy = json['consumer']['name'];
    reviewDate = json['date'];
    reviewRating = json['rating'];
    reviewContent = json['review'];
  }
}
