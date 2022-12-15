import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/Screens/ProfilePages/editProfilePage.dart';
import 'package:partner/Screens/ProfilePages/widgets/addresses.dart';
import 'package:partner/Screens/ProfilePages/widgets/allReviews.dart';
import 'package:partner/Screens/ProfilePages/widgets/description.dart';
import 'package:partner/Screens/ProfilePages/widgets/details.dart';
import 'package:partner/Screens/ProfilePages/widgets/header.dart';
import 'package:partner/Screens/ProfilePages/widgets/services.dart';
import 'package:partner/entity/ProfileEntity.dart';
import 'package:partner/provider/mProvider/profilePictureProvider.dart';
import 'package:partner/values/MyColors.dart';

import '../../state/ProfileState.dart';
import '../../values/MyTextstyle.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).getProfileInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.purewhite,
        elevation: 5,
      ),
      body: Consumer(builder: (context, ref, child) {
        ProfileState? state = ref.watch(profileNotifierProvider);
        return () {
          return state != null
              ? state.profileEntity!.when(
                  data: (data) {
                    var partnerEntity =
                        state.profileEntity!.value!.partnerInfoEntity;
                    var reviews = state.profileEntity!.value!.reviews;
                    var shop = state.profileEntity!.value!.shopEntity;
                    var services = state.profileEntity!.value!.shopService;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Header(
                            text: "Profile",
                            button_text: "Edit",
                            bgColor: MyColors.purple,
                            textColor: MyColors.purewhite,
                            buttonVisibility: true,
                            path: EditProfilePage(state.profileEntity!.value),
                          ),
                          Container(
                            color: MyColors.lightYellow,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Details(partnerEntity!, shop!),
                                Description(shop.shopDescription!),
                                Addresses(partnerEntity, shop),
                              ],
                            ),
                          ),
                          Text(
                            'Your Service',
                            style: MyTextStyle.text1,
                          ),
                          Container(
                            color: MyColors.lightYellow,
                            width: double.infinity,
                            child: Services(services!),
                          ),
                          Header(
                            text: "Reviews",
                            button_text: "See All",
                            path: AllRevivews(
                                state.profileEntity!.value!.reviews!),
                            bgColor: MyColors.purple,
                            textColor: MyColors.purewhite,
                            buttonVisibility: reviews!.isNotEmpty,
                          ),
                          reviews.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('No Reviews'),
                                    ],
                                  ),
                                )
                              : Container(
                                  color: MyColors.lightYellow,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            reviews.length >= 2 ? 2 : null,
                                        itemBuilder: (context, index) =>
                                            getReviewItem(index, reviews)),
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                  error: (error, txt) => Text(txt.toString()),
                  loading: () => Center(
                        child: CircularProgressIndicator(),
                      ))
              : Container();
        }();
      }),
    );
  }

  getReviewItem(int index, List<ReviewEntity> item) {
    ReviewEntity entity = item[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          border: Border.all(
            color: MyColors.yellow,
          ),
          color: MyColors.purewhite,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(flex: 2, child: Text(entity.reviewBy!)),
                Text(
                  '12/12/2020',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 3.0),
              child: RatingBarIndicator(
                itemSize: 10.0,
                rating: (int.parse(entity.reviewRating!) * 5) / 5,
                itemBuilder: (BuildContext context, int index) {
                  return const Icon(Icons.star, color: Colors.amber);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 3.0),
              child: Text(entity.reviewContent!),
            )
          ],
        ),
      ),
    );
  }
}
