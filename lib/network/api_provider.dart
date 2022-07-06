import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nitya/model/about_us.dart';
import 'package:nitya/model/bookmark_model.dart';
import 'package:nitya/model/bytes_model.dart';
import 'package:nitya/model/event.dart';
import 'package:nitya/model/feedback.dart';
import 'package:nitya/model/login_model.dart';
import 'package:nitya/model/new_signup_model.dart';
import 'package:nitya/model/notification_model.dart';
import 'package:nitya/model/post.dart';
import 'package:nitya/model/query.dart';
import 'package:nitya/model/search.dart';
import 'package:nitya/model/sign_model.dart';
import 'package:nitya/model/sign_up_error_model.dart';
import 'package:nitya/model/user.dart';
import 'package:nitya/utils/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:http/http.dart' as http;
//diao ek bar crearw
class ApiProvider {
  Dio _dioClient = Dio(
    BaseOptions(
      baseUrl: "$BASE_URL",
      headers: {
        'Appversion': '1.0',
        'Ostype': Platform.isAndroid ? 'android' : 'ios'
      },
    ),
  )..interceptors.add(
      PrettyDioLogger(
          requestBody: true, requestHeader: true, responseBody: true),
    );

  Future<SignUpModel> signUp(String name, String country_code, String phone, String email, String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _map = {
      "name": name,
      "country_code": country_code,
      "phone_no": phone,
      "email": email,
      "reg_id": fcmToken,
    };
    print("RE BODY: " + jsonEncode(_map));

    try {
      Response response =
          await _dioClient.post('/sign-up.php', data: jsonEncode(_map));
      print("Sign up ${response.data}");
      if (response.data != "") {
        var responsedata = response.data;
        prefs.setString(
            'token', responsedata['user']['access_token'].toString());
        if (response.data['success'] == true)
          return SignUpModel.fromJson(response.data);
        else
          return SignUpModel.fromJson(response.data);
      } else {
        return SignUpModel.fromJson(response.data);
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }
      return SignUpModel.fromJson(e.response.data);
    }
  }

  Future<dynamic> verifySignUpOtp(String otp, String phone) async {
    final _map = {'otp': otp, 'phone_no': phone};

    Response response = await _dioClient
        .post('/signupverified.php', data: _map)
        .catchError((e) {
      return Future.error(e.message);
    });

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      //we hit the api and status was ok
      if (response.data['success'] == true) {
        return response.data;
      } else {
        return Future.error(response.data);
      }
    } else {
      //could not hit the api may be because of internet
      return Future.error(response.statusMessage);
    }
  }

  Future<LoginResponse> login(String phone) async {
    final _map = Map();
    _map['phone_no'] = phone;

    try {
      Response response = await _dioClient.post('/sign-in.php', data: _map);
      print(response.data);
      if (response.data != "") {
        if (response.data['success'] == true)
          return LoginResponse.fromJson(response.data);
        else
          return LoginResponse.fromError(response.data['message']);
      } else {
        return LoginResponse.fromError("No data");
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }
      return LoginResponse.fromError("$e");
    }
  }

  Future<dynamic> verifyLoginOtp(String otp, String phone) async {
    final _map = {'otp': otp, 'phone_no': phone};

    Response response = await _dioClient
        .post('/signinverified.php', data: _map)
        .catchError((e) {
      return Future.error(e.message);
    });

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      //we hit the api and status was ok
      if (response.data['success'] == true) {
        return response.data;
      } else {
        return Future.error(response.data);
      }
    } else {
      //could not hit the api may be because of internet
      return Future.error(response.statusMessage);
    }
  }

  Future<String> resendOTP(String phone, int isPhoneVerified) async {
    final _map = {'is_phone_verified': isPhoneVerified, 'phone_no': phone};

    Response response =
        await _dioClient.post('/resendotp.php', data: _map).catchError((e) {
      return Future.error(e.message);
    });

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      return response.data['message'];
    } else {
      //could not hit the api may be because of internet
      return Future.error(response.statusMessage);
    }
  }

  // Future<PostResponse> fetchPosts(String accessToken, count) async {
  //   final _map = {'access_token': accessToken};
  //
  //   try {
  //     Response response = await _dioClient
  //         .post('/getpost.php', data: _map, queryParameters: {'page': count});
  //     if (response.data != "") {
  //       if (response.data['success']) {
  //         return PostResponse.fromJson(response.data);
  //       } else {
  //         return PostResponse.withError(
  //             response.data['message'] ?? "Something went wrong");
  //       }
  //     } else {
  //       return PostResponse.withError("Nothing here");
  //     }
  //   } catch (error, stacktrace) {
  //     print("Exception occured: $error stackTrace: $stacktrace");
  //     var e = error;
  //     if (error is DioError) {
  //       e = getErrorMsg(e.type);
  //     }
  //
  //     return PostResponse.withError("$e");
  //   }
  // }

  Future<PostResponse> fetchAllPosts(String accessToken, page, String postType) async {
    final _map = {'access_token': accessToken, "post_type": postType};
    try {
      Response response = await _dioClient.post('/getposttype.php',
          data: _map, queryParameters: {'page': page});

      print(response.data);

      if (response.data != "") {
        if (response.data['success']) {
          return PostResponse.fromJson(response.data);
        } else {
          return PostResponse.withError(
              response.data['message'] ?? "Something went wrong");
        }
      } else {
        return PostResponse.withError("Nothing here");
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }
      return PostResponse.withError("$e");
    }
  }

  Future<PostResponse> fetchUpdates(String accessToken, page, String filter) async {
    print("token " + accessToken);
    print("Page " + page.toString());
    print("filter " + filter.toString());
    final _map = {"access_token": accessToken, "filter": filter};
    try {
      Response response = await _dioClient
          .post('/getfilter.php', data: _map, queryParameters: {'page': page});
      if (response.data != "") {
        if (response.data['success']) {
          return PostResponse.fromJson(response.data);
        } else {
          return PostResponse.withError(
              response.data['message'] ?? "Something went wrong");
        }
      } else {
        return PostResponse.withError("Nothing here");
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }
      return PostResponse.withError("$e");
    }
  }

  Future<EventResponse> fetchEvents(String accessToken) async {
    final _map = {'access_token': accessToken};
    try {
      Response response = await _dioClient.post('/events.php', data: _map);
      if (response.data != "") {
        if (response.data['success']) {
          return EventResponse.fromJson(response.data);
        } else {
          return EventResponse.withError(
              response.data['message'] ?? "Something went wrong");
        }
      } else {
        return EventResponse.withError("Nothing here");
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }

      return EventResponse.withError("$e");
    }
  }

  Future<bool> postQuery(Query query) async {
    Map _body = Map();
    _body['access_token'] = query.accessToken;
    _body['name'] = query.name;
    _body['phone_no'] = query.phoneNo;
    _body['email'] = query.email;
    _body['message'] = query.message;

    Response response = await _dioClient.post('/query.php', data: _body);
    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<bool> postFeedback(Feedback feedback) async {
    Map _body = Map();
    _body['access_token'] = feedback.accessToken;
    _body['name'] = feedback.name;
    _body['phone_no'] = feedback.phoneNo;
    _body['email'] = feedback.email;
    _body['message'] = feedback.message;
    _body['post_id'] = feedback.postId;
    _body['title'] = feedback.title;

    Response response =
        await _dioClient.post('/feedback_post.php', data: _body);
    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<bool> addBookmark(String accessToken, String postId) async {
    Map body = Map();
    body['access_token'] = accessToken;
    body['post_id'] = postId;

    Response response = await _dioClient.post('/bookmarks.php', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        return true;
      } else {
        return Future.error(response.data['message']);
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<bool> deleteBookmark(String accessToken, String postId) async {
    Map body = Map();
    body['access_token'] = accessToken;
    body['post_id'] = postId;

    Response response =
        await _dioClient.post('/remove_bookmarks.php', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<List<BookmarkModel>> fetchBookmarks(String accessToken) async {
    Map body = Map();
    body['access_token'] = accessToken;

    Response response = await _dioClient.post('/getbookmarks.php', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data == "") {
        return Future.error("Servers have some issue, please try again later");
      }
      if (response.data['success'] == true) {
        var v = response.data['bookmarks'];
        List<BookmarkModel> bookmarks = List();
        for (int i = 0; i < v.length; i++) {
          bookmarks.add(BookmarkModel.fromJson(v[i]));
        }
        return bookmarks;
      } else {
        return [];
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<ByteResponse> fetchBytes(String accessToken) async {
    final _map = {'access_token': accessToken};
    try {
      Response response = await _dioClient.post('/bytes.php', data: _map);
      if (response.data['success'])
        return ByteResponse.fromJson(response.data);
      else
        return ByteResponse.withError(response.data['message']);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }
      return ByteResponse.withError("Something went wrong");
    }
  }

//  Future<List<BytesModel>> fetchBytes(String accessToken) async {
//    Map body = Map();
//    body['access_token'] = accessToken;
//
//    Response response = await _dioClient.post('/bytes.php', data: body);
//
//    if (response.statusCode == HttpStatus.ok) {
//      if (response.data == "") {
//        return Future.error("Servers have some issues");
//      }
//      if (response.data['success'] == true) {
//        var v = response.data['bytes'];
//        List<BytesModel> bytes = List();
//        for (int i = 0; i < v.length; i++) {
//          bytes.add(BytesModel.fromJson(v[i]));
//        }
//        return bytes;
//      } else {
//        return [];
//      }
//    } else {
//      return Future.error('Something Went Wrong');
//    }
//  }

  Future<List<NotificationModel>> fetchNotification() async {
    Response response = await _dioClient.get('/notification.php')
        .catchError((e) => print(e.toString()));
    print(response.data);
    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success']) {
        var v = response.data['notifications'];
        List<NotificationModel> notifcations = [];
        for (int i = 0; i < v.length; i++) {
          notifcations.add(NotificationModel.fromJson(v[i]));
        }
        return notifcations;
      } else {
        return [];
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<User> fetchUser(String accessToken) async {
    Map body = Map();
    body['access_token'] = accessToken;

    Response response = await _dioClient.post('/user_fetch.php', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        var v = response.data['user'];
        return User.fromJson(v);
      } else {
        return Future.error("You token has been expired or wrong");
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<User> updateProfile(String accessToken, String name, String email,
      String phoneNo, String org, String designation) async {
    Map body = {
      "access_token": accessToken,
      "name": name,
      "org": org,
      "designation": designation,
      "email": email,
      "phone_no": phoneNo
    };

    Response response =
        await _dioClient.post('/profile_update.php', data: body);
    print(response);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        var v = response.data['user'];
        return User.fromJson(v);
      } else {
        return Future.error(response.data['message']);
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  Future<List<Search>> search(String keyword, String accessToken) async {
    Map body = Map();
    body['access_token'] = accessToken;
    body['keyword'] = keyword;

    Response response = await _dioClient.post('/searchget.php', data: body);

    if (response.statusCode == HttpStatus.ok) {
      if (response.data == "") {
        return Future.error("Servers have some issues");
      }
      if (response.data['success'] == true) {
        var v = SearchResult.fromJson(response.data);
        return v.search;
      } else {
        return Future.error(response.data['message']);
      }
    } else {
      return Future.error('Something Went Wrong');
    }
  }

  String getErrorMsg(DioErrorType type) {
    switch (type) {
      case DioErrorType.connectTimeout:
        // TODO: Handle this case.
        return "Connection timeout";
        break;
      case DioErrorType.sendTimeout:
        // TODO: Handle this case.
        return "Send timeout";
        break;
      case DioErrorType.receiveTimeout:
        // TODO: Handle this case.
        return "Receive timeout";
        break;
      case DioErrorType.response:
        // TODO: Handle this case.
        return "Response timeout";
        break;
      case DioErrorType.cancel:
        // TODO: Handle this case.
        return "Request has been cancelled";
        break;
      case DioErrorType.other:
        // TODO: Handle this case.
        return "Could not connect";
        break;
      default:
        return "Something went wrong";
        break;
    }
  }

  Future<AboutUsModel> aboutUs() async {
    try {
      Response response = await _dioClient.get('/aboutus.php');

      if (response.data != "") {
        if (response.data['success'] == true)
          return AboutUsModel.fromJson(response.data);
        else
          return null;
      } else {
        return null;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      var e = error;
      if (error is DioError) {
        e = getErrorMsg(e.type);
      }
      return null;
    }
  }
}
