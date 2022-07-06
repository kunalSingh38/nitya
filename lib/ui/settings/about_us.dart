// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nitya/model/about_us.dart';
import 'package:nitya/repository/repo.dart';
import 'package:nitya/ui/common/notification_app_bar.dart';
import 'package:nitya/ui/post/post_detail_page.dart';
import 'package:nitya/utils/constants.dart';
import 'package:nitya/utils/image_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final String companyEmail = "Info@nityatax.com";

  Repository repository = new Repository();
  AboutUsModel aboutUs;

  @override
  void initState() {
    super.initState();
    callAboutUs();

    // FirebaseAnalytics().setCurrentScreen(
    //   screenName: "About Us",
    // );
  }

  callAboutUs() async {
    aboutUs = await repository.aboutUs();
    setState(() {
      //futurebuilder
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: NotificationAppBar('About Us'),
          preferredSize: Size.fromHeight(56)),
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                LOGO,
                height: 156,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        String url =
                            "market://details?id=com.entrepreter.nityaassociation";
                        lunchUrl(url);
                      },
                      splashColor: kPrimaryColor.withOpacity(0.2),
                      child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          "Rate Us",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kPrimaryColor)),
                      ),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: InkWell(
                      splashColor: kPrimaryColor.withOpacity(0.2),
                      onTap: () {
                        _launchURL(companyEmail, "", "");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          "Email",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kPrimaryColor)),
                      ),
                    )),
                  ],
                ),
              ),
              FutureBuilder(
                  future: repository.aboutUs(),
                  builder: (context, AsyncSnapshot<AboutUsModel> snapshot) {
                    if (snapshot.hasData) {
                      final document = parse(snapshot.data.post.text);
                      final String parsedString =
                          parse(document.body.text).documentElement.text;
                      return Container(
                        child: Text(
                          parsedString,
                          style: TextStyle(fontSize: 16, color: Colors.black45),
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    try {
      await launch(url);
    } catch (e) {
      print("$e");
    }
  }
}
