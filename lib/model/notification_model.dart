// class NotificationModel {
//   String notificationId;
//   int notificationType;
//   List<String> readBy;
//   String title;
//   String post;
//   String description;
//   String name;
//   String createdAt;
//   String message;
//   String image;
//   String action;
//   String actionDestination;
//   String markRead;
//
//   NotificationModel(
//       {this.notificationId,
//         this.notificationType,
//         this.readBy,
//         this.title,
//         this.post,
//         this.description,
//         this.name,
//         this.createdAt,
//         this.message,
//         this.image,
//         this.action,
//         this.actionDestination,
//         this.markRead});
//
//   NotificationModel.fromJson(Map<String, dynamic> json) {
//     notificationId = json['notification_id'];
//     notificationType = json['notification_type'];
//     readBy = json['read_by'].cast<String>();
//     title = json['title'];
//     post = json['post'];
//     description = json['description'];
//     name = json['name'];
//     createdAt = json['created_at'];
//     message = json['message'];
//     image = json['image'];
//     action = json['action'];
//     actionDestination = json['action_destination'];
//     markRead = json['mark_read'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['notification_id'] = this.notificationId;
//     data['notification_type'] = this.notificationType;
//     data['read_by'] = this.readBy;
//     data['title'] = this.title;
//     data['post'] = this.post;
//     data['description'] = this.description;
//     data['name'] = this.name;
//     data['created_at'] = this.createdAt;
//     data['message'] = this.message;
//     data['image'] = this.image;
//     data['action'] = this.action;
//     data['action_destination'] = this.actionDestination;
//     data['mark_read'] = this.markRead;
//     return data;
//   }
// }
//

// class NotificationModel {
//   bool success;
//   List<Notifications> notifications;
//
//   NotificationModel({this.success, this.notifications});
//
//   NotificationModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['notifications'] != null) {
//       notifications = new List<Notifications>();
//       json['notifications'].forEach((v) {
//         notifications.add(new Notifications.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.notifications != null) {
//       data['notifications'] =
//           this.notifications.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class NotificationModel {
  String notificationId;
  List<String> readBy;
  String title;
  String post;
  String description;
  String name;
  String createdAt;
  String message;
  String image;
  String action;
  String actionDestination;
  String markRead;

  NotificationModel(
      {this.notificationId,
      this.readBy,
      this.title,
      this.post,
      this.description,
      this.name,
      this.createdAt,
      this.message,
      this.image,
      this.action,
      this.actionDestination,
      this.markRead});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    readBy = json['read_by'].cast<String>();
    title = json['title'];
    post = json['post'];
    description = json['description'];
    name = json['name'];
    createdAt = json['created_at'];
    message = json['message'];
    image = json['image'];
    action = json['action'];
    actionDestination = json['action_destination'];
    markRead = json['mark_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = this.notificationId;
    data['read_by'] = this.readBy;
    data['title'] = this.title;
    data['post'] = this.post;
    data['description'] = this.description;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['message'] = this.message;
    data['image'] = this.image;
    data['action'] = this.action;
    data['action_destination'] = this.actionDestination;
    data['mark_read'] = this.markRead;
    return data;
  }
}
