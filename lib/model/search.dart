class SearchResult {
  bool success;
  List<Search> search;

  SearchResult({this.success, this.search});

  SearchResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['search'] != null) {
      search = new List<Search>();
      json['search'].forEach((v) {
        search.add(new Search.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.search != null) {
      data['search'] = this.search.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Search {
  int postId;
  int postType;
  String title;
  String description;
  List<String> bookmarkedBy;
  String url;
  String timestamp;
  int eventsId;
  int urlType;
  String registrationLink;

  Search(
      {this.postId,
      this.postType,
      this.title,
      this.description,
      this.bookmarkedBy,
      this.url,
      this.timestamp,
      this.eventsId,
      this.urlType,
      this.registrationLink});

  Search.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    postType = json['post_type'];
    title = json['title'];
    description = json['description'];
    bookmarkedBy = json['bookmarked_by'].cast<String>();
    url = json['url'];
    timestamp = json['timestamp'];
    eventsId = json['events_id'];
    urlType = json['url_type'];
    registrationLink = json['registration_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['post_type'] = this.postType;
    data['title'] = this.title;
    data['description'] = this.description;
    data['bookmarked_by'] = this.bookmarkedBy;
    data['url'] = this.url;
    data['timestamp'] = this.timestamp;
    data['events_id'] = this.eventsId;
    data['url_type'] = this.urlType;
    data['registration_link'] = this.registrationLink;
    return data;
  }
}
