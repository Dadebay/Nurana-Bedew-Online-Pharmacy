class NewsModel {
  final String? title;
  final String? description;

  NewsModel({this.title, this.description});

  factory NewsModel.fromJson(Map<dynamic, dynamic> json) {
    return NewsModel(
      title: json["title"],
      description: json["text"],
    );
  }
}
