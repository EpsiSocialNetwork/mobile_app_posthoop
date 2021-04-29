class User{
  String uid;
  String email;
  String password;
  String fullname;
  String username;
  String description;
  DateTime createdAt;
  String pictureProfile;
  String codeCountry;

  User({this.uid, this.email, this.password, this.fullname, this.username, this.description, this.createdAt,this.pictureProfile, this.codeCountry});

  factory User.fromJson(Map<String, dynamic> json) => User(
      uid: json["uid"],
      email: json["email"],
      password: json["password"],
      fullname: json["fullname"],
      username: json["username"],
      description: json["description"],
      createdAt: DateTime.parse(json["createdAt"]),
      pictureProfile: json["pictureProfile"],
      codeCountry: json["codeCountry"]
  );
}