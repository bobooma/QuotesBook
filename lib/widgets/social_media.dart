import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

enum Social { facebook, twitter, email, linkedin, whatsapp }

class SocialMedia extends StatelessWidget {
  final String img;
  final Axis axis;

  const SocialMedia({
    Key? key,
    required this.img,
    required this.axis,
  }) : super(key: key);

// ****



  Future<void> share(Social platform) async {
    const subject = " share everywhere  myQuotes";
    const txt = " share everywhere ";
    final urlShare = Uri.encodeComponent(img);
    final urls = {
      Social.facebook:
          "https://www.facebook.com/sharer/sharer.php?u=$urlShare&t=$txt",
      Social.twitter:
          "https://www.twitter.com/intent/tweet?url=$urlShare&t=$txt",
      Social.email: "mailto:?subject=$subject&body=$txt\n\n$urlShare",
      Social.linkedin:
          "https://www.linkedin.com/shareArticle?mini=true&url=$urlShare",
      Social.whatsapp: "https://www.api.whatsapp.com/send?text=$txt$urlShare",
    };
    final url = urls[platform]!;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    axis;

    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'SHARE',
            style: TextStyle(
              fontFamily: "Rubik",
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          socialBtn(
              icon: FontAwesomeIcons.facebookSquare,
              color: facebookColor,
              onclicked: () => share(Social.facebook)),
          const SizedBox(
            width: 10,
          ),
          socialBtn(
              icon: FontAwesomeIcons.twitter,
              color: twittetColor,
              onclicked: () => share(Social.twitter)),
          const SizedBox(
            width: 10,
          ),
          socialBtn(
              icon: Icons.mail,
              color: mailColor,
              onclicked: () => share(Social.email)),
          const SizedBox(
            width: 10,
          ),
          socialBtn(
              icon: FontAwesomeIcons.linkedinIn,
              color: linkedinColor,
              onclicked: () => share(Social.linkedin)),
          const SizedBox(
            width: 10,
          ),
          socialBtn(
              icon: FontAwesomeIcons.whatsapp,
              color: whatsappColor,
              onclicked: () => share(Social.whatsapp))
        ],
      ),
    );
  }
}

Widget socialBtn({
  required IconData icon,
  required Color color,
  required VoidCallback onclicked,
}) =>
    Expanded(
      child: InkWell(
        child: Center(
          child: FaIcon(
            icon,
            color: color,
            size: 40,
          ),
        ),
        onTap: onclicked,
      ),
    );
