import 'package:flutter/material.dart';
import 'package:nitya/main.dart';
import 'package:nitya/utils/constants.dart';

class ErrorPage extends StatelessWidget {
  final String errorMsg;
  final VoidCallback retry;

  ErrorPage({this.errorMsg, this.retry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            errorMsg,
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: kPrimaryColor)),
            onPressed: retry ?? () => RestartWidget.restartApp(context),
            child: Text(
              "Retry",
              style: TextStyle(color: kPrimaryColor),
            ),
          )
        ],
      ),
    );
  }
}
