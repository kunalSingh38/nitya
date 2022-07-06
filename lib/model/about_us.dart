class AboutUsModel {
  bool success;
  Post post;

  AboutUsModel({this.success, this.post});

  AboutUsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    return data;
  }
}

class Post {
  int id;
  String heading;
  String text;

  Post({this.id, this.heading, this.text});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heading = json['heading'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['heading'] = this.heading;
    data['text'] = this.text;
    return data;
  }
}
