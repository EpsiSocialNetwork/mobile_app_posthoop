class Post{
  String uid;
  String text;
  String uidUser;
  String urlImage;
  DateTime createdAt;

  Post({this.uid, this.text, this.uidUser, this.urlImage, this.createdAt});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    uid: json["uid"],
    text: json["text"],
    uidUser: json["uidUser"],
    urlImage: json["urlImage"],
    createdAt: DateTime.parse(json["createdAt"])
  );
}