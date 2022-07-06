class BytesModel {
  int id;
  String news;
  String createdAt;

  BytesModel({this.id, this.news, this.createdAt});

  BytesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    news = json['news'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['news'] = this.news;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class ByteResponse {
  final List<BytesModel> bytes;
  final String error;

  ByteResponse(this.bytes, this.error);

  ByteResponse.fromJson(Map<String, dynamic> json)
      : bytes = json.isNotEmpty
            ? (json["bytes"] as List)
                .map((i) => new BytesModel.fromJson(i))
                .toList()
            : List(),
        error = "";

  ByteResponse.withError(String errorValue)
      : bytes = List(),
        error = errorValue;
}
