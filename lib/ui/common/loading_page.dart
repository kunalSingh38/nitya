import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final String msg;

  LoadingPage(this.msg);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            strokeWidth: 2,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            msg,
            style: TextStyle(fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }
}
