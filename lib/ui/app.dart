import 'dart:io';

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nitya/model/bottom_nav_item.dart';
import 'package:nitya/model/navigation_util.dart';
import 'package:nitya/model/notification_model.dart';
import 'package:nitya/ui/byte/bytes.dart';
import 'package:nitya/ui/contact.dart';
import 'package:nitya/ui/event/events.dart';
import 'package:nitya/ui/home/home_page.dart';
import 'package:nitya/ui/notifications/bloc/notification_bloc.dart';
import 'package:nitya/ui/notifications/notifications.dart';
import 'package:nitya/ui/query/query_page.dart';
import 'package:nitya/ui/search/search_page.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:nitya/utils/constants.dart';
import 'package:nitya/utils/image_helper.dart';
import 'package:provider/provider.dart';

import 'dynamic_page_post.dart';

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  final List<BottomNavItem> _bottomBar = [
    BottomNavItem('Home', HOME_ICON),
    BottomNavItem('Bulletin', BULLETIN),
    BottomNavItem('Search', SEARCH_ICON),
    BottomNavItem('Events', EVENT_ICON),
    BottomNavItem('Query', QUERY_ICON),
  ];

  final List<Widget> _bottomBody = [
    HomePage(),
    BytesPage(),
    SearchPage(),
    Events(),
    QueryPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initDynamicLinks();
  }

  // void initDynamicLinks() async {
  //   // final PendingDynamicLinkData data =
  //   //     await FirebaseDynamicLinks.instance.getInitialLink();
  //   // final Uri deeplink = data?.link;
  //   print(deeplink);

  //   if (deeplink != null) {
  //     if (deeplink.path == '/post') {
  //       String id = deeplink.queryParameters['id'];
  //       print(id);
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (_) => DynamicPage(id, ContentType.POST)));
  //     }
  //     if (deeplink.path == '/event') {
  //       String id = deeplink.queryParameters['id'];
  //       print(id);
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (_) => DynamicPage(id, ContentType.EVENT)));
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationModel>(context);
    return AnimatedContainer(
      transform: Matrix4.translationValues(navigation.xOffset, 0, 0),
      child: Scaffold(
          body: AbsorbPointer(
            child: _bottomBody[navigation.bottomIndex],
            absorbing: navigation.isDrawerOpen,
          ),
          appBar: AppBar(
              brightness: Brightness.dark,
              elevation: 0,
              backgroundColor: kPrimaryColor,
              leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  navigation.isDrawerOpen
                      ? navigation.closeDrawer()
                      : navigation.openDrawer();
                },
              ),
              centerTitle: true,
              title: Text(
                "NITYA Tax Associates",
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                StreamBuilder(
                    stream: notificationBloc.notifications,
                    builder: (context, snapshot) {
                      return Stack(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NotificationPage()));
                              }),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Builder(builder: (context) {
                              if (snapshot.hasData) {
                                List<NotificationModel> no = snapshot.data;

                                int length = no
                                    .where((element) => !AppUtils
                                        .readNotifications
                                        .contains(element.notificationId))
                                    .length;

                                return length >= 1
                                    ? Container(
                                        width: 16,
                                        height: 16,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: Border.all(
                                                color: kPrimaryColor)),
                                        child: FittedBox(
                                          child: Text(
                                            length.toString(),
                                            style:
                                                TextStyle(color: kPrimaryColor),
                                          ),
                                        ),
                                      )
                                    : Container();
                              } else {
                                return Container();
                              }
                            }),
                          )
                        ],
                      );
                    })
              ]),
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                navigation.setMainIndex(index);
              },
              currentIndex: navigation.bottomIndex,
              unselectedFontSize: 12,
              selectedFontSize: 12,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: kPrimaryColor,
              items: _bottomBar.map((e) {
                return BottomNavigationBarItem(
                    icon: Container(
                      padding: EdgeInsets.all(4),
                      child: SvgPicture.asset(
                        e.icon,
                        color: _bottomBar.indexOf(e) == navigation.bottomIndex
                            ? kPrimaryColor
                            : Colors.grey,
                        fit: BoxFit.fill,
                        width: 20,
                        height: 20,
                      ),
                    ),
                    label: e.title.toString());
              }).toList())),
      duration: Duration(milliseconds: 200),
    );
  }
}
