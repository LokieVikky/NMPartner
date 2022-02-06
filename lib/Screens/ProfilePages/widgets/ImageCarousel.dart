import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:provider/provider.dart';

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  @override
  Widget build(BuildContext context) {
    final _dataProvider =
        Provider.of<ProfilePageProvider>(context, listen: true);
    if (_dataProvider.snapshot != null) {
      var a = _dataProvider.snapshot.get('shopImages');
      List imgList = a['carouselImages'];
      if (imgList.isNotEmpty) {
        return Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: CarouselSlider.builder(
            itemCount: imgList.isEmpty ? 0 : imgList.length,
            options: CarouselOptions(
              // height: 400,
              autoPlay: true,
              aspectRatio: 2.0,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 2000),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            itemBuilder: (context, index, realIdx) {
              return Container(
                child: Center(
                    child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: 1000,
                  imageUrl: imgList[index],
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
              );
            },
          ),
        );
      }
    }
    return Container();
  }
}
