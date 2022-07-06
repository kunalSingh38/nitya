import 'package:intl/intl.dart';

class Post {
  int id;
  int postType;
  String title;
  String description;
  int category;
  List<String> bookmarkedBy;
  String url;
  String pdffile;
  String pdftitle;
  String timestamp;
  String postDate;

  Post(
      {this.id,
      this.postType,
      this.title,
      this.description,
      this.category,
      this.bookmarkedBy,
      this.url,
      this.pdffile,
      this.pdftitle,
      this.timestamp});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postType = json['post_type'];
    title = json['title'];
    description = json['description'];
    category = json['category'];
    bookmarkedBy = json['bookmarked_by'].cast<String>();
    url = json['url'];
    pdffile = json['pdffile'];
    pdftitle = json['pdftitle'];
    timestamp = json['timestamp'];
    if (timestamp != null) {
      try {
        postDate =
            DateFormat('dd:MM:yyyy').format(DateTime.tryParse(timestamp));
      } catch (e) {
        postDate = timestamp;
      }
    } else {
      postDate = '01:01:1980';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_type'] = this.postType;
    data['title'] = this.title;
    data['description'] = this.description;
    data['category'] = this.category;
    data['bookmarked_by'] = this.bookmarkedBy;
    data['url'] = this.url;
    data['pdffile'] = this.pdffile;
    data['pdftitle'] = this.pdftitle;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class PostResponse {
  final List<Post> posts;
  final String error;
  final int total;
  final bool success;

  PostResponse(this.posts, this.error, this.total, this.success);

  PostResponse.fromJson(Map<String, dynamic> json)
      : posts = json['post'] == null
            ? []
            : (json["post"] as List).map((i) => new Post.fromJson(i)).toList(),
        error = null,
        total = json['total'],
        success = json['success'];

  PostResponse.withError(String errorValue)
      : posts = List(),
        error = errorValue,
        total = 0,
        success = false;
}
