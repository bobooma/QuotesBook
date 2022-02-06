import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_quotes/screens/quote.dart';
import 'package:my_quotes/widgets/my_card.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    Key? key,
    required this.quotes,
    required this.media,
  }) : super(key: key);

  final Stream<QuerySnapshot<Map<String, dynamic>>> quotes;
  final Size media;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: quotes,
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
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                String content = snapshot.data.docs[index]["content"];
                String quoteId = snapshot.data.docs[index].id;

                return Slidable(
                  key: UniqueKey(),
                  endActionPane: ActionPane(
                    dismissible: DismissiblePane(
                      onDismissed: () async {
                        await FirebaseFirestore.instance
                            .runTransaction((Transaction myTransaction) async {
                          myTransaction
                              .delete(snapshot.data.docs[index].reference);
                        });
                        // Remove this Slidable from the widget tree.
                      },
                    ),
                    motion: const DrawerMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        label: 'Delete',
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        onPressed: (context) {},
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
                            imgUrl: snapshot.data.docs[index]["imgUrl"],
                            docId: quoteId,
                            index: index,
                            imgs: snapshot,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: media.width,
                      height: media.height * 0.2,
                      child: Stack(children: [
                        Positioned(child: MyCard(details: content)),
                        Positioned(
                          top: 5,
                          child: CachedNetworkImage(
                              imageUrl: snapshot.data.docs[index]["imgUrl"],
                              imageBuilder: (_, p) {
                                return Container(
                                  height: media.height * 0.2,
                                  width: media.height * 0.2,
                                  decoration: BoxDecoration(
                                    boxShadow: const [BoxShadow(blurRadius: 2)],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: p,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ]),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
