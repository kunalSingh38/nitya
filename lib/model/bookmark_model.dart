import 'package:nitya/model/post.dart';

class BookmarkModel {
  int bookmarksId;
  int postId;
  String accessToken;
  Post post;
  String createdAt;

  BookmarkModel(
      {this.bookmarksId,
      this.postId,
      this.accessToken,
      this.post,
      this.createdAt});

  BookmarkModel.fromJson(Map<String, dynamic> json) {
    bookmarksId = json['bookmarks_id'];
    postId = json['post_id'];
    accessToken = json['access_token'];
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookmarks_id'] = this.bookmarksId;
    data['post_id'] = this.postId;
    data['access_token'] = this.accessToken;
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}
