class Feedback {
  String accessToken;
  String name;
  String phoneNo;
  String email;
  String message;
  int postId;
  String title;

  Feedback(
      {this.accessToken,
      this.name,
      this.phoneNo,
      this.email,
      this.message,
      this.postId,
      this.title});

  Feedback.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    name = json['name'];
    phoneNo = json['phone_no'];
    email = json['email'];
    message = json['message'];
    postId = json['post_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['name'] = this.name;
    data['phone_no'] = this.phoneNo;
    data['email'] = this.email;
    data['message'] = this.message;
    data['post_id'] = this.postId;
    data['title'] = this.title;
    return data;
  }
}
