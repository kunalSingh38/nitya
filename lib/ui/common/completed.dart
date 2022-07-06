import 'package:flutter/material.dart';
import 'package:nitya/model/navigation_util.dart';
import 'package:nitya/ui/main_page.dart';
import 'package:nitya/utils/constants.dart';
import 'package:provider/provider.dart';

class Completed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1)).then((onValue) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainPage()));
    });
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Completed !",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: 176,
              height: 176,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kPrimaryColor, width: 12)),
              child: Icon(
                Icons.done,
                size: 124,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              "Thanks for choosing Nitya Tax Associates",
              style: TextStyle(color: Colors.black38),
            )
          ],
        ),
      ),
    );
  }
}
