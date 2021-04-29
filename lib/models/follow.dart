class Follow{
  String uidUser;
  String followUidUser;
  DateTime createdAt;

  Follow({this.uidUser, this.followUidUser, this.createdAt});

  factory Follow.fromJson(Map<String, dynamic> json) => Follow(
    uidUser: json["uidUser"],
    followUidUser: json["followUidUser"],
    createdAt: DateTime.parse(json["createdAt"])
  );
}