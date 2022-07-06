import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nitya/model/notification_model.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:nitya/utils/constants.dart';
import 'package:nitya/utils/prefs_helper.dart';

import '../dynamic_page_post.dart';

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;

  const NotificationItem(this.notification);
  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    // final timeAgo = timeago.format(DateTime.parse(widget.notification.message));
    bool read = AppUtils.readNotifications.contains(widget.notification.notificationId);
    return Container(
      color: read ? Colors.transparent : kPrimaryColor.withOpacity(0.2),
      child: Column(
        children: [
          ListTile(
            onTap: () => onNotificationsTap(context),
            dense: true,
            leading: Container(
                width: 56,
                color: Colors.grey,
                child: Builder(builder: (context) {
                  try {
                    return Container(
                      height: 124,
                      width: 96,
                      color: Colors.grey.shade200,
                      child: CachedNetworkImage(
                        imageUrl: widget.notification.image,
                        placeholder: (context, url) => Container(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(height: 2, child: LinearProgressIndicator())),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: 196,
                        fit: BoxFit.fill,
                      ),
                    );
                  } catch (e) {
                    return Center(
                      child: FittedBox(
                        child: Text("No Image"),
                      ),
                    );
                  }
                })),
            title: Text(
              widget.notification.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              widget.notification.description,maxLines: 2,
              style: TextStyle(fontSize: 12),
            ),
            trailing: Text(
              "${DateFormat().add_yMd().format(DateTime.parse("${widget.notification.message}"))},"
              " ${DateFormat().add_jm().format(DateTime.parse("${widget.notification.message}"))}",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
              onPressed: read ? null : () => markAsRead(),
              child: Text("Mark as read"),
              textColor: kPrimaryColor,
            ),
          )
        ],
      ),
    );
  }

  void onNotificationsTap(BuildContext context) {
    markAsRead();
    print(widget.notification.description);
    if (widget.notification.description == "Bulletin") {
      //print("show Bulletins");
      showBulletins(context);
    } else {
      //print("No Bulletins");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DynamicPage(widget.notification.post, widget.notification.notificationId.compareTo("1") == 0 ? ContentType.EVENT : ContentType.POST)));
    }
  }

  void markAsRead() {
    setState(() {
      if (!AppUtils.readNotifications.contains(widget.notification.notificationId))
          AppUtils.readNotifications.add(widget.notification.notificationId);
          PrefsHelper.saveNotificationsRead(widget.notification.notificationId);
    });
  }

  void showBulletins(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
        builder: (_) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text("${widget.notification.title}")),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.close,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: Text(
                    "${widget.notification.description}",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
