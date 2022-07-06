import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/user.dart';
import 'package:nitya/ui/no_internet.dart';
import 'package:nitya/utils/prefs_helper.dart';
import 'package:rxdart/rxdart.dart';

import 'package:html/parser.dart';

class AppUtils {
  static User currentUser;
  static PublishSubject<bool> internetStream = PublishSubject();
  static String fcmToken;
  static List<String> readNotifications = [];

  dispose() {
    internetStream?.close();
  }

  //here goes the function
  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  AppUtils() {
    print("caa");
    PrefsHelper.getReadNotification().then((value) {
      print(value);
      readNotifications = value ?? [];
    });
    Connectivity connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((result) {
      print(result);
      if (result == ConnectivityResult.none) {
        internetStream.sink.add(true);
      } else {
        internetStream.sink.add(false);
      }
    });
  }

  static void showLoadingDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  static void showError(String message, GlobalKey<ScaffoldState> key,
      [actionLabel, VoidCallback onTap]) {
    key.currentState?.showSnackBar(SnackBar(
      content: new Text(message),
      duration: new Duration(seconds: 3),
      action: actionLabel != null
          ? SnackBarAction(label: actionLabel, onPressed: onTap)
          : null,
    ));
  }

  static String namify(String text) {
    if (text != null)
      return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  static String getPostTypeByCode(int code) {
    switch (code) {
      case 0:
        return "Update";
        break;
      case 1:
        return "Article";
        break;
      case 2:
        return "Video";
        break;
      case 3:
        return "Event";
        break;
      default:
        return "All";
        break;
    }
  }

  static String showErrorPage(DioErrorType type, context) {
    switch (type) {
      case DioErrorType.other:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => NoInternet("No Internet Connection")));
        break;
      case DioErrorType.connectTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.sendTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.receiveTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.response:
        // TODO: Handle this case.
        break;
      case DioErrorType.cancel:
        // TODO: Handle this case.
        break;
    }
  }
}
