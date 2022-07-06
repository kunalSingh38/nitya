import 'dart:convert';

// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/categorylistdata.dart';
import 'package:nitya/ui/home/updates/all.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdatesPage extends StatefulWidget {
  @override
  _UpdatesPageState createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  List<String> categories = <String>[];

  List<Category> dummycatlist = <Category>[];

  String value = "All";
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();
    // FirebaseAnalytics().setCurrentScreen(
    //   screenName: "Update",
    // );
  }

  _getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    categories.clear();
    List<String> dummylist = [];
    var response = await http.post(
      Uri.parse('https://app.nityatax.com/application/api/getcategory.php'),
      body: jsonEncode(<String, String>{
        "access_token": prefs.getString('token'),
      }),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Iterable list = json.decode(response.body)['category'];
      List<Category> catlist = list.map((m) => Category.fromJson(m)).toList();
      dummylist.add("All");
      setState(() {
        dummycatlist.addAll(catlist);
      });
      for (var i = 0; i < catlist.length; i++) {
        dummylist.add(catlist[i].catName);
      }
      setState(() {
        categories.addAll(dummylist);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          height: 56,
          child: ListTile(
            title: Text(
              "Filter By",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            trailing: DropdownButton<String>(
              value: value,
              selectedItemBuilder: (_) {
                return categories
                    .map((e) => Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            e,
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Colors.black87),
                          ),
                        ))
                    .toList();
              },
              items: categories.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (va) {
                categories.remove("All");
                value = va;
                for (int i = 0; i < dummycatlist.length; i++) {
                  if (value == dummycatlist[i].catName) {
                    setState(() {
                      index = int.parse(dummycatlist[i].id);
                    });
                    return;
                  }
                }
              },
            ),
          ),
        ),
        body: AllUpdatez(index));
  }
}
