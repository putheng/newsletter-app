  import 'dart:convert';
  
class News {
  int id;
  String title;
  String description;
  String slug;
  String image;
  String url;
  String create;
  String user;

  News({
    this.id,
    this.title,
    this.description,
    this.slug,
    this.image,
    this.url,
    this.create,
    this.user
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    slug: json["slug"],
    image: json["image"],
    url: json["url"],
    create: json["created_at"],
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "slug": slug,
    "image": image,
    "url": url,
    "create": create,
    "user": user,
  };
}

News newsFromJson(String str) {
  final jsonData = json.decode(str);
  return News.fromJson(jsonData['data']);
}

List<News> getNewsJson(String str) {
  final jsonData = json.decode(str);
  return List<News>.from(jsonData['data'].map((x) => News.fromJson(x)));
}