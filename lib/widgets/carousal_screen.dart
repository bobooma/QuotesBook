import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Sliders extends StatelessWidget {
  Sliders({
    required this.imgs,
  });

  final List imgs;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return imgs == null
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 100),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          )
        : Center(
            child: Stack(
              children: [
                CarouselSlider.builder(
                    itemCount: imgs.length,
                    itemBuilder: (ctx, i, _) {
                      return Expanded(
                        child: CachedNetworkImage(
                          imageUrl: imgs[i],
                          imageBuilder: (_, p) {
                            return Container(
                              margin: EdgeInsets.all(5),
                              // width: width / 3,
                              height: height / 2,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: p, fit: BoxFit.cover)),
                            );
                          },
                          progressIndicatorBuilder: (context, url, progress) {
                            return Container(
                              width: width / 2,
                              height: height / 2,
                              color: Colors.grey.withOpacity(.4),
                              child: Center(
                                  child: SpinKitThreeBounce(
                                      size: 30, color: Colors.black)),
                            );
                          },
                        ),
                      );
                    },
                    options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        viewportFraction: 0.6,
                        // enlargeStrategy: CenterPageEnlargeStrategy.height,

                        enlargeCenterPage: true,
                        autoPlayInterval: Duration(seconds: 5)))
              ],
            ),
          );
  }
}
