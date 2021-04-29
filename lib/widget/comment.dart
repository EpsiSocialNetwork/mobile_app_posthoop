import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Mobile App packages
import 'package:mobile_app_posthoop/models/comment.dart';
import 'package:mobile_app_posthoop/models/user.dart';
import 'package:mobile_app_posthoop/services/authenticateService.dart';

class CommentWidget extends StatefulWidget {
  CommentWidget({Key key,@required this.comment}) : super(key: key);

  final Comment comment;

  @override
  _CommentWidget createState() => _CommentWidget();
}

class _CommentWidget extends State<CommentWidget> {

  User _user = new User();

  @override
  void initState() {
    super.initState();
    _user.username = "Username";
    getUsername();
  }

  String displayedDate() {
    var difference = "N/A";
    var daysDifference = DateTime.now().difference(widget.comment.createdAt).inDays;
    if(daysDifference == 0){
      var hoursDifference =  DateTime.now().difference(widget.comment.createdAt).inHours;
      if (hoursDifference < 1){
        var minutesDifference = DateTime.now().difference(widget.comment.createdAt).inMinutes;
        if(minutesDifference > 1){
          difference = minutesDifference.toString() + "min";
        } else {
          difference = DateTime.now().difference(widget.comment.createdAt).inSeconds.toString() + "sec";
        }
      } else {
        difference = hoursDifference.toString() + "h";
      }
    } else {
      difference = daysDifference.toString() + "d";
    }
    return difference;
  }

  void getUsername() async {
    final response = await http.get(Uri.parse('https://user.mignon.chat/user/${widget.comment.uidUser}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthenticateService.token}',
        }
    );
    if(response.statusCode == 200){
        var user = jsonDecode(response.body);
        this.setState(() {
          _user = User.fromJson(user);
        });
      };
    }


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album),
            title: Text("${_user.fullname} - ${displayedDate()}"),
            subtitle: Text(widget.comment.text, style: TextStyle(fontSize: 20)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: Icon(Icons.favorite_border),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
              TextButton(
                child: Icon(Icons.share),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ]
          )
        ]
      )
    );
  }
}