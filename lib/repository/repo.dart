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
import 'package:nitya/model/user.dart';
import 'package:nitya/network/api_provider.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<SignUpModel> signUp(String name, String countryCode, String phone,
          String email, String fcmToken) =>
      apiProvider.signUp(name, countryCode, phone, email, fcmToken);

  Future<dynamic> verifySignedUpOtp(String otp, String phone) =>
      apiProvider.verifySignUpOtp(otp, phone);

  Future<LoginResponse> login(String phone) => apiProvider.login(phone);

  Future<dynamic> verifyLoginOtp(String otp, String phone) =>
      apiProvider.verifyLoginOtp(otp, phone);

  Future<dynamic> resendOTP(int isPhoneVerified, String phone) =>
      apiProvider.resendOTP(phone, isPhoneVerified);

  Future<PostResponse> fetchAllPosts(
          String accessToken, page, String postType) =>
      apiProvider.fetchAllPosts(accessToken, page, postType);
  Future<PostResponse> fetchUpdates(String accessToken, page, String filter) =>
      apiProvider.fetchUpdates(accessToken, page, filter);

  Future<EventResponse> fetchEvents(String accessToken) =>
      apiProvider.fetchEvents(accessToken);

  Future<bool> postQuery(Query query) => apiProvider.postQuery(query);

  Future<bool> postFeedback(Feedback feedback) =>
      apiProvider.postFeedback(feedback);

  Future<bool> addBookmark(String token, String id) =>
      apiProvider.addBookmark(token, id);

  Future<bool> removeBookmark(String token, String id) =>
      apiProvider.deleteBookmark(token, id);

  Future<List<BookmarkModel>> fetchBookmarks(String token) =>
      apiProvider.fetchBookmarks(token);

  Future<ByteResponse> fetchBytes(String token) =>
      apiProvider.fetchBytes(token);

  Future<List<NotificationModel>> fetchNotifications() =>
      apiProvider.fetchNotification();

  Future<User> updateUser(
          accessToken, name, email, phoneNo, org, designation) =>
      apiProvider.updateProfile(
          accessToken, name, email, phoneNo, org, designation);

  Future<List<Search>> search(String keyword, String accessToken) =>
      apiProvider.search(keyword, accessToken);

  Future<AboutUsModel> aboutUs() => apiProvider.aboutUs();
}
