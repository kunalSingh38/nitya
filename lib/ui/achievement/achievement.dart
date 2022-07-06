import 'dart:convert';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nitya/helper/dialog_helper.dart';
import 'package:nitya/model/achievementlistdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({Key key}) : super(key: key);

  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAchievemt();
    // FirebaseAnalytics().setCurrentScreen(
    //   screenName: "Achievement",
    // );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xff58C6CF),
        title: Text("Achievement", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: _getAchievemt(),
              builder: (context, AsyncSnapshot snapshot) {
                List<Achievement> list = snapshot.data;
                if (!snapshot.hasData) {
                  return Center(
                      child: Container(
                          height: 24.0,
                          width: 24.0,
                          child: const CircularProgressIndicator()));
                } else {
                  return ListView.separated(
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) {
                        return const Divider(
                            color: Colors.transparent, height: 6.0);
                      },
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _achivementItem(
                            list[index].image, list[index].title);
                      });
                }
              }),
        ),
      ),
    );
  }

  Widget _achivementItem(String image, String title) {
    return GestureDetector(
      onTap: () {
        DialogHelper.viewimagedialog(image, title, context);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        width: double.infinity,
        child: Card(
          elevation: 4.0,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.infinity,
                padding: EdgeInsets.all(5.0),
                child: Image.network(image, fit: BoxFit.contain),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: double.infinity,
                  child: Text(title,
                      textScaleFactor: 1.1,
                      style:
                          TextStyle(color: Colors.black, letterSpacing: 1.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Achievement>> _getAchievemt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(
      Uri.parse('https://app.nityatax.com/application/api/achievement.php'),
      body: jsonEncode(<String, String>{
        "access_token": prefs.getString('token'),
      }),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Iterable list = json.decode(response.body)['category'];
      List<Achievement> catlist =
          list.map((m) => Achievement.fromJson(m)).toList();
      return catlist;
    } else {}
  }
}
