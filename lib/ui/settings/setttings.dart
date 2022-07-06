import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nitya/ui/common/notification_app_bar.dart';
import 'package:nitya/ui/settings/about_us.dart';
import 'package:nitya/ui/settings/terms_n_conditions.dart';
import 'package:nitya/ui/signup/sign_up.dart';
import 'package:nitya/utils/constants.dart';
import 'package:nitya/utils/prefs_helper.dart';

class Settings extends StatelessWidget {
  final List _settings = ['About Us', 'Privacy Policy', "Logout"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: NotificationAppBar('Settings'),
          preferredSize: Size.fromHeight(56)),
      body: ListView.separated(
        itemCount: _settings.length,
        itemBuilder: (_, index) {
          return ListTile(
            onTap: () {
              switch (index) {
                case 0:
                  //open about us
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => AboutUs()));
                  break;
                case 1:
                  //open terms
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TermsAndConditions()));
                  break;
                case 2:
                  _sureLogout(context);
              }
            },
            title: Text(_settings[index]),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Container(
          height: 1,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Future<bool> _sureLogout(BuildContext context) {
    return showDialog(
          builder: (context) => AlertDialog(
            actionsPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            title: Text('Logout?'),
            content: Text(
              "This will log you out from this device.",
              style: TextStyle(color: Colors.black54),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
              FlatButton(
                onPressed: () {
                  PrefsHelper.deleteUser();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => SignUp()),
                      (route) => false);
                },
                child: Text(
                  'OKAY',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          ),
          context: context,
        ) ??
        false;
  }
}
