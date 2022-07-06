import 'user.dart';

class LoginResponse {
  String error;
  User user;

  LoginResponse(this.error, this.user);

  LoginResponse.fromJson(Map<String, dynamic> json) {
    this.user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  LoginResponse.fromError(String errorValue) {
    this.error = errorValue;
  }
}
