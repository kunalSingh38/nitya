class Query {
  String accessToken;
  String name;
  String phoneNo;
  String email;
  String message;

  Query({this.accessToken, this.name, this.phoneNo, this.email, this.message});

  Query.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    name = json['name'];
    phoneNo = json['phone_no'];
    email = json['email'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['name'] = this.name;
    data['phone_no'] = this.phoneNo;
    data['email'] = this.email;
    data['message'] = this.message;
    return data;
  }
}
