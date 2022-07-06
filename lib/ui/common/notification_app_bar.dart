import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/notification_model.dart';
import 'package:nitya/ui/notifications/bloc/notification_bloc.dart';
import 'package:nitya/ui/notifications/notifications.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:nitya/utils/constants.dart';

class NotificationAppBar extends StatelessWidget {
  final String title;

  NotificationAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Color(0xff58C6CF),
      brightness: Brightness.dark,
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white),
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
                        no = no
                            .where((element) => !AppUtils.readNotifications
                                .contains(element.notificationId))
                            .toList();
                        // no.removeWhere((element) => AppUtils.readNotifications
                        //     .contains(element.notificationId));
                        return no.length >= 1
                            ? Container(
                                width: 16,
                                height: 16,
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(color: kPrimaryColor)),
                                child: FittedBox(
                                  child: Text(
                                    "${no.length}",
                                    style: TextStyle(color: kPrimaryColor),
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
      ],
    );
  }
}
