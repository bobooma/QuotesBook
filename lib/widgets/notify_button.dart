import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NotifyjBtn extends StatelessWidget {
  String serverToken =
      "AAAAPxFK7S8:APA91bGOnpETUHJhPVYegc3-fC3OwOKQ0w5NMCOZpOaR10udI48DANWa62t3kJ3Am_hVHy78jAkQPfF3kDAL_fuqiWpYaccg3xRiVHCt4h4nUnVgMX0EbDbJzL319IWmGQ_xDR4TvT8L";

  // sendNotify(String title, String body, String id) async {
  //   await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
  //       headers: <String, String>{
  //         "Content-Type": "application/json",
  //         "Authorization": "key=$serverToken"
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         "notification": <String, dynamic>{
  //           "body": body.toString(),
  //           "title": title.toString()
  //         },
  //         "priority": "high",
  //         "data": <String, dynamic>{
  //           "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //           "id": id.toString(),
  //           "name": "ahmed",
  //           "lastname": "rabie"
  //         },
  //         "to": token
  //       }));
  //   print(token);
  // }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.aspect_ratio),
      onPressed: () {
        // sendNotify("title", "body", "id");
      },
    );
  }
}
