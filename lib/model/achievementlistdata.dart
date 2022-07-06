class AchievementlistData {
  bool success;
  List<Achievement> category;

  AchievementlistData({this.success, this.category});

  AchievementlistData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['category'] != null) {
      category = <Achievement>[];
      json['category'].forEach((v) {
        category.add(new Achievement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Achievement {
  String id;
  String title;
  String image;

  Achievement({this.id, this.title, this.image});

  Achievement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    return data;
  }
}
