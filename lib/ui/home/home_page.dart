// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/navigation_util.dart';
import 'package:nitya/model/post.dart';
import 'package:nitya/ui/common/error_page.dart';
import 'package:nitya/ui/common/loading_page.dart';
import 'package:nitya/ui/common/post_item.dart';
import 'package:nitya/ui/home/all_posts.dart';
import 'package:nitya/ui/home/articles.dart';
import 'package:nitya/ui/home/updates.dart';
import 'package:nitya/ui/home/videos.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final int index;

  const HomePage({Key key, @required this.index}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _tabs = ['All', 'Updates', 'Articles', 'Videos'];

  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    // FirebaseAnalytics().setCurrentScreen(
    //   screenName: "Home",
    // );
  }

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationModel>(context);
    _currentPage = navigation.homeIndex;
    return Scaffold(
      body: buildPosts(navigation),
      appBar: buildAppBar(navigation),
    );
  }

  List b = [
    AllPosts(),
    UpdatesPage(),
    ArticlesPage(),
    VideoPage(),
  ];

  buildPosts(NavigationModel navigation) {
    return b[navigation.homeIndex];
  }

  PreferredSize buildAppBar(navigation) {
    return PreferredSize(
      child: Container(
        color: Colors.grey.shade200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _tabs.map((e) {
            int indexOfCurrentItem = _tabs.indexOf(e);
            return InkWell(
              onTap: () {
                navigation.setHomeIndex(indexOfCurrentItem);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: _currentPage == indexOfCurrentItem
                                ? Colors.grey.shade600
                                : Colors.transparent,
                            width: 2))),
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: Text(e),
              ),
            );
          }).toList(),
        ),
      ),
      preferredSize: Size.fromHeight(36),
    );
  }
}
