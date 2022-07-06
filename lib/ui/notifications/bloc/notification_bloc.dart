import 'package:nitya/model/notification_model.dart';
import 'package:nitya/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class NotificationBloc extends BaseBloc {
  static final NotificationBloc _notificationBloc =
      NotificationBloc._internal();

  factory NotificationBloc() {
    return _notificationBloc;
  }

  NotificationBloc._internal();

  final BehaviorSubject<List<NotificationModel>> notificationStream =
      BehaviorSubject<List<NotificationModel>>();
  final _notificationErrorStream = PublishSubject<String>();

  Stream<List<NotificationModel>> get notifications =>
      notificationStream.stream;

  Stream<String> get notificationsError => _notificationErrorStream.stream;

  getNotifications() async {
    await repository.fetchNotifications().catchError((e) {
      _notificationErrorStream.add(e.toString());
    }).then((List<NotificationModel> value) {
      if (value != null) {
        notificationStream.add(value);
      }
    });
  }

  dispose() {
    notificationStream.close();
    _notificationErrorStream?.close();
  }
}

final notificationBloc = NotificationBloc();
