class User {
  var userId;
  String name;
  String email;
  String countryCode;
  String phoneNo;
  String accessToken;


  User(this.userId, this.name, this.email,this.countryCode, this.phoneNo, this.accessToken);

  User.fromJson(Map<String, dynamic> map)
      : userId = map["user_id"],
        name = map["name"],
        email = map["email"],
        countryCode = map['country_code'],
        phoneNo = map["phone_no"],
        accessToken = map["access_token"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['country_code'] = this.countryCode;
    data['phone_no'] = phoneNo;
    data['access_token'] = accessToken;
    return data;
  }
}

//
// class User {
//   int userId;
//   String name;
//   String email;
//   String countryCode;
//   String phoneNo;
//   String regId;
//   String accessToken;
//
//   User(
//       {this.userId,
//         this.name,
//         this.email,
//         this.countryCode,
//         this.phoneNo,
//         this.regId,
//         this.accessToken});
//
//   User.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     name = json['name'];
//     email = json['email'];
//     countryCode = json['country_code'];
//     phoneNo = json['phone_no'];
//     regId = json['reg_id'];
//     accessToken = json['access_token'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_id'] = this.userId;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['country_code'] = this.countryCode;
//     data['phone_no'] = this.phoneNo;
//     data['reg_id'] = this.regId;
//     data['access_token'] = this.accessToken;
//     return data;
//   }
// }