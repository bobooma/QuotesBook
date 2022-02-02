import 'package:flutter/material.dart';
import 'package:my_quotes/screens/upload_screen.dart';

class AdminBtn extends StatelessWidget {
  const AdminBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => UploadScreen()));
      },
      icon: Icon(Icons.add_a_photo),
    );
  }
}
