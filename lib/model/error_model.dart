class Error {
  bool success;
  String message;
  int errorCode;

  Error({this.success, this.message, this.errorCode});

  Error.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    errorCode = json['error_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['error_code'] = this.errorCode;
    return data;
  }
}
