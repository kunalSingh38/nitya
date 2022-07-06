import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nitya/model/notification_model.dart';
import 'package:nitya/ui/notifications/bloc/notification_bloc.dart';
import 'package:nitya/utils/app_utils.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      //For iOS request permission first.
      _firebaseMessaging.requestPermission();
      //   _firebaseMessaging.configure();

      //    For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      AppUtils.fcmToken = token;

      _initialized = true;
      // getMessage();
    }
  }

  void getMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      notificationBloc.getNotifications();
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      print(message);
      notificationBloc.getNotifications();
    });
  }
}
