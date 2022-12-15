import 'package:partner/entity/partnerInfoEntity.dart';
import 'package:partner/entity/shopInfoEntity.dart';

import '../models/mModel/modelService.dart';

class ProfileEntity {
  // todo should add services
  List<ReviewEntity>? reviews;
  ShopEntity? shopEntity;
  List<ModelService>? shopService;
  PartnerInfoEntity? partnerInfoEntity;

  ProfileEntity({this.reviews, this.shopEntity, this.shopService, this.partnerInfoEntity});
}

class ReviewEntity {
  String? reviewBy;
  String? reviewDate;
  String? reviewRating;
  String? reviewContent;

  ReviewEntity(
      {this.reviewBy, this.reviewDate, this.reviewRating, this.reviewContent});
}
