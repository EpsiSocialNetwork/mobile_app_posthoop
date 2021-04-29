class Comment{
  String uid;
  String text;
  String uidUser;
  String uidPost;
  DateTime createdAt;

  Comment({this.uid, this.text, this.uidUser, this.uidPost, this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
      uid: json["uid"],
      text: json["text"],
      uidUser: json["uidUser"],
      uidPost: json["uidPost"],
      createdAt: DateTime.parse(json["createdAt"])
  );
}