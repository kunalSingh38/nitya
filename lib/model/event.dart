class EventModel {
  int id;
  int urlType;
  int postType;
  String title;
  String description;
  List<String> bookmarkedBy;
  String url;
  String pdffile;
  String pdftitle;
  String registrationLink;
  String timestamp;

  EventModel(
      {this.id,
      this.urlType,
      this.postType,
      this.title,
      this.description,
      this.bookmarkedBy,
      this.url,
      this.pdffile,
      this.pdftitle,
      this.registrationLink,
      this.timestamp});

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    urlType = json['url_type'];
    postType = json['post_type'];
    title = json['title'];
    description = json['description'];
    bookmarkedBy = json['bookmarked_by'].cast<String>();
    url = json['url'];
    pdffile = json['pdffile'];
    pdftitle = json['pdftitle'];
    registrationLink = json['registration_link'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url_type'] = this.urlType;
    data['post_type'] = this.postType;
    data['title'] = this.title;
    data['description'] = this.description;
    data['bookmarked_by'] = this.bookmarkedBy;
    data['url'] = this.url;
    data['pdffile'] = this.pdffile;
    data['pdftitle'] = this.pdftitle;
    data['registration_link'] = this.registrationLink;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class EventResponse {
  List<EventModel> events;
  String error;

  EventResponse(this.events, this.error);

  EventResponse.fromJson(Map<String, dynamic> json)
      : events = json['events'] == null
            ? []
            : (json["events"] as List)
                .map((i) => new EventModel.fromJson(i))
                .toList(),
        error = null;

  EventResponse.withError(String errorValue)
      : events = List(),
        error = errorValue;
}
