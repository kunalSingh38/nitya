import 'package:flutter/material.dart';
import 'package:nitya/helper/view_image_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogHelper {
  static viewimagedialog(String image, String desc, context) => showDialog(
      context: context,
      builder: (context) => ViewImageDialog(
            image: image,
            desc: desc,
          ));
}
