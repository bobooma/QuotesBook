import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BackgrounSliders extends StatelessWidget {
  const BackgrounSliders({
    Key? key,
    required this.imgs,
  }) : super(key: key);

  final AsyncSnapshot imgs;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return imgs == null
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            ),
          )
        : Expanded(
            child: Center(
              child: CarouselSlider.builder(
                  itemCount: imgs.data.docs.length,
                  itemBuilder: (ctx, i, _) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop(imgs.data.docs[i]["b"]);
                      },
                      child: CachedNetworkImage(
                        imageUrl: imgs.data.docs[i]["b"],
                        imageBuilder: (_, p) {
                          return Container(
                            margin: const EdgeInsets.all(1),
                            // width: width / 3,
                            height: height / 2,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 3.0, offset: Offset(0.0, 2)),
                                ],
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: p, fit: BoxFit.fill)),
                          );
                        },
                        progressIndicatorBuilder: (context, url, progress) {
                          return Container(
                            width: width / 2,
                            height: height / 2,
                            color: Colors.grey.withOpacity(.4),
                            child: const Center(
                                child: SpinKitThreeBounce(
                                    size: 30, color: Colors.pink)),
                          );
                        },
                      ),
                    );
                  },
                  options: CarouselOptions(
                      height: 600,
                      autoPlay: true,
                      viewportFraction: 0.7,
                      // enlargeStrategy: CenterPageEnlargeStrategy.height,

                      enlargeCenterPage: true,
                      autoPlayInterval: const Duration(seconds: 2))),
            ),
          );
  }
}
