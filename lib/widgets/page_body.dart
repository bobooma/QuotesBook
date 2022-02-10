import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_quotes/screens/quote.dart';
import 'package:my_quotes/widgets/my_card.dart';

import '../providers/utils.dart';

const int maxFailedLoadAttempt = 3;

class PageBody extends StatefulWidget {
  const PageBody({
    Key? key,
    required this.quotes,
    required this.media,
    required this.bannerId,
    required this.inlineId,
  }) : super(key: key);

  final String bannerId;
  final String inlineId;

  final Stream<QuerySnapshot<Map<String, dynamic>>> quotes;
  final Size media;

  @override
  State<PageBody> createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  late BannerAd homeBanner;
  late BannerAd inlineBanner;

  final inlineIndex = 3;
  bool isHomeLoaded = false;
  bool isInlineLoaded = false;

  int getListvItemIndx(int index) {
    if (index >= inlineIndex && isInlineLoaded) {
      return index - 1;
    } else {
      return index;
    }
  }

  void createHomeBanner() {
    homeBanner = BannerAd(
        size: AdSize.banner,
        adUnitId: widget.bannerId,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            isHomeLoaded = true;
            //
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest());

    homeBanner.load();
  }

  void createInlineBanner() {
    inlineBanner = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: widget.inlineId,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            isInlineLoaded = true;
            // setState(() {
            // });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest());

    inlineBanner.load();
  }

  @override
  void initState() {
    createHomeBanner();
    createInlineBanner();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    homeBanner.dispose();
    // interstitialAd?.dispose();
    inlineBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: isHomeLoaded
          ? SizedBox(
              height: homeBanner.size.height.toDouble(),
              width: homeBanner.size.width.toDouble(),
              child: AdWidget(ad: homeBanner),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: widget.quotes,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text('error .....');
            }
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final len = snapshot.data.docs.length;
            return ListView.builder(
                itemCount: len + (isInlineLoaded && len >= 3 ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  print("******");
                  print(index);
                  print(len + (isInlineLoaded ? 1 : 0));
                  if (isInlineLoaded && index == inlineIndex) {
                    return Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      width: inlineBanner.size.width.toDouble(),
                      height: inlineBanner.size.height.toDouble(),
                      child: AdWidget(ad: inlineBanner),
                    );
                  } else {
                    String content =
                        snapshot.data.docs[getListvItemIndx(index)]["content"];
                    String quoteId =
                        snapshot.data.docs[getListvItemIndx(index)].id;

                    return Slidable(
                      key: UniqueKey(),
                      endActionPane: ActionPane(
                        dismissible: DismissiblePane(
                          onDismissed: () async {
                            // Remove this Slidable from the widget tree.
                          },
                        ),
                        motion: const DrawerMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            label: 'Download',
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            onPressed: (context) {
                              Utils.save(
                                  snapshot.data.docs[getListvItemIndx(index)]
                                      ["imgUrl"],
                                  context);
                            },
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuoteImage(
                                content: content,
                                imgUrl: snapshot.data
                                    .docs[getListvItemIndx(index)]["imgUrl"],
                                docId: quoteId,
                                index: getListvItemIndx(index),
                                imgs: snapshot,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: widget.media.width,
                          height: widget.media.height * 0.2,
                          child: Stack(children: [
                            Positioned(child: MyCard(details: content)),
                            Positioned(
                              top: 5,
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data
                                    .docs[getListvItemIndx(index)]["imgUrl"],
                                imageBuilder: (_, p) {
                                  return Container(
                                    height: height * 0.2,
                                    width: height * 0.2,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(blurRadius: 2)
                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: p,
                                      ),
                                    ),
                                  );
                                },
                                progressIndicatorBuilder:
                                    (context, url, progress) {
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
                            ),
                          ]),
                        ),
                      ),
                    );
                  }
                });
          },
        ),
      ),
    );
  }
}
