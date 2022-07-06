import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewImageDialog extends StatelessWidget {
  String image;
  String desc;

  ViewImageDialog({Key key, this.image, this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.55,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: Image.network(image, fit: BoxFit.fill),
              ),
              Divider(color: Colors.black, height: 5.0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(desc, style: TextStyle(color: Colors.black)),
                ),
              )
            ],
          ),
        ),
      );
}
