import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:partner/entity/ProfileEntity.dart';

import '../../../values/MyColors.dart';

class AllRevivews extends StatefulWidget {
  List<ReviewEntity> reviewList;

  AllRevivews(this.reviewList, {Key? key}) : super(key: key);

  @override
  _AllRevivewsState createState() => _AllRevivewsState();
}

class _AllRevivewsState extends State<AllRevivews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.purewhite,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyColors.pureblack,
          ),
          onPressed: () => Navigator.popAndPushNamed(context, '/homePage'),
        ),
        elevation: 5,
        centerTitle: true,
        title: Text('Shop Reviews'),
      ),
      body: ListView.builder(
          itemCount: widget.reviewList.length,
          itemBuilder: (context, index) => getReviewItem(index)),
    );
  }

  getReviewItem(int index) {
    ReviewEntity entity = widget.reviewList[index];
    print('rate -> ' + entity.reviewRating.toString());
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
                rating: (double.parse(entity.reviewRating!) * 5) / 5,
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
