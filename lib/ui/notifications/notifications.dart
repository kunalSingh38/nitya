import 'dart:io';

// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/notification_model.dart';
import 'package:nitya/ui/notifications/bloc/notification_bloc.dart';
import 'package:nitya/ui/notifications/notification_item.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:nitya/utils/constants.dart';
import 'package:nitya/utils/prefs_helper.dart';

List<NotificationModel> notifications = [];

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> readNotifications = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readNotifications = AppUtils.readNotifications;
    notificationBloc.getNotifications();

    // FirebaseAnalytics().setCurrentScreen(
    //   screenName: "Notification",
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () => markAllAsRead(notifications),
              child: Text("Mark all as read"),
              textColor: Colors.white,
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: notificationBloc.notifications,
          builder: (context, snapshot) {
            print("Snap: ${snapshot.hasData}");
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                print("Data:${snapshot.data} ");
                notifications = snapshot.data;
              }
              return Container(
                child: notifications.isEmpty
                    ? Center(
                        child: Text("No Notifications"),
                      )
                    : ListView.separated(
                        itemCount: notifications.length,
                        separatorBuilder: (_, __) => Container(
                              height: 1,
                              color: Colors.white,
                            ),
                        itemBuilder: (_, index) {
                          NotificationModel m = notifications[index];
                          try {
                            return NotificationItem(m);
                          } catch (e) {
                            return Center(
                              child: Text('Some error occurred'),
                            );
                          }
                        }),
              );
            } else if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text(snapshot.error.toString()),
                ),
              );
            } else {
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
                        "Fetching Notifications...",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      )
                    ]),
              );
            }
          }),
    );
  }

  void markAllAsRead(List<NotificationModel> notifications) {
    setState(() {
      AppUtils.readNotifications = notifications.map((e) {
        PrefsHelper.saveNotificationsRead(e.notificationId);
        return e.notificationId;
      }).toList();
    });
  }
}
