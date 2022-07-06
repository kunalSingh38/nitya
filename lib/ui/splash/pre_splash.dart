import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nitya/model/user.dart';
import 'package:nitya/network/api_provider.dart';
import 'package:nitya/ui/disclaimer_dialog.dart';
import 'package:nitya/ui/main_page.dart';
import 'package:nitya/ui/signup/sign_up.dart';
import 'package:nitya/ui/splash/splash_screen.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:nitya/utils/constants.dart';
import 'package:nitya/utils/fcm_helper.dart';
import 'package:nitya/utils/image_helper.dart';
import 'package:nitya/utils/prefs_helper.dart';

class PreSplash extends StatefulWidget {
  @override
  _PreSplashState createState() => _PreSplashState();
}

class _PreSplashState extends State<PreSplash> {
  // final PushNotificationsManager fcmManager = PushNotificationsManager();

  @override
  void initState() {
    super.initState();
    //  fcmManager.init();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor,
        statusBarIconBrightness: Brightness.light));
    AppUtils();
    checkUser();
  }

  checkUser() async {
    User user = await PrefsHelper.getLoggedUser();
    AppUtils.currentUser = user;
    if (user == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => SignUp()));
    } else {
      //debugPrint("Access Token: "+AppUtils.currentUser.accessToken);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: InkWell(
        onTap: () {},
        child: Center(
          child: SvgPicture.asset(
            LOGO,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
