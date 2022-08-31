import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nitya/main.dart';
import 'package:nitya/model/navigation_util.dart';
import 'package:nitya/ui/app.dart';
import 'package:nitya/ui/bookmark/bloc/bookmark_bloc.dart';
import 'package:nitya/ui/byte/bloc/bytes_bloc.dart';
import 'package:nitya/ui/dynamic_page_post.dart';
import 'package:nitya/ui/event/bloc/event_bloc.dart';
import 'package:nitya/ui/no_internet.dart';
import 'package:nitya/ui/notifications/bloc/notification_bloc.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:provider/provider.dart';

import 'drawer_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // FirebaseAnalyticsObserver observer =
    //     FirebaseAnalyticsObserver(analytics: FirebaseAnalytics());
    // FirebaseAnalytics().setCurrentScreen(
    //   screenName: "DashBoard",
    // );

    String accessToke = AppUtils.currentUser.accessToken;
    getConnectionStatus();
    ByteBloc().fetchBytes(accessToke);
    EventBloc().fetchEvents(accessToke);
    BookmarkBloc().fetchBookmarks(accessToke);
    notificationBloc.getNotifications();
    onNewLink();
  }

  var streamConnectionStatus;

  getConnectionStatus() async {
    streamConnectionStatus = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!

      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          hasConnection = true;
        });
      } else {
        setState(() {
          hasConnection = false;
        });
      }
    });
  }

  void onNewLink() async {
    // FirebaseDynamicLinks.instance.onLink(onError: (e) {
    //   print(e.details);
    //   return null;
    // }, onSuccess: (PendingDynamicLinkData d) {
    //   if (d.link.path == '/post') {
    //     print("go to post");
    //     String id = d.link.queryParameters['id'];
    //     print(id);
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (_) => DynamicPage(id, ContentType.POST)));
    //   }
    //   if (d.link.path == '/event') {
    //     print("go to event");
    //     String id = d.link.queryParameters['id'];
    //     print(id);
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (_) => DynamicPage(id, ContentType.EVENT)));
    //   }
    //   return null;
    // });
  }

  bool hasConnection = true;

  @override
  Widget build(BuildContext context) {
    return hasConnection
        ? ChangeNotifierProvider(
            create: (BuildContext context) => NavigationModel(),
            child: Stack(
              children: <Widget>[
                DrawerPage(),
                AppBody(),
              ],
            ),
          )
        : NoInternet("Check Internet Connection");
  }
}
