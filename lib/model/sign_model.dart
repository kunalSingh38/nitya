import 'package:nitya/model/user.dart';

class SignResponse {
  int errorCode;
  String error;
  User user;

  SignResponse(this.error, this.user, this.errorCode);

  SignResponse.fromJson(Map<String, dynamic> json) {
    this.user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  SignResponse.fromError(String errorValue, int errorCode) {
    this.error = errorValue;
    this.errorCode = errorCode;
  }
}
