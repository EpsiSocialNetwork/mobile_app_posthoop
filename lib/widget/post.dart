import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_posthoop/models/CommentArguments.dart';
import 'dart:convert';

// Mobile App packages
import 'package:mobile_app_posthoop/services/authenticateService.dart';
import 'package:mobile_app_posthoop/models/post.dart';
import 'package:mobile_app_posthoop/models/user.dart';

class PostWidget extends StatefulWidget {
  PostWidget({Key key,@required this.post, this.onPressed}) : super(key: key);

  final Post post;
  final GestureTapCallback onPressed;

  @override
  _PostWidget createState() => _PostWidget();
}

class _PostWidget extends State<PostWidget> {

  User _user = new User();
  bool _postIsLiked = false;
  int _numberOfLike = 0;
  int _numberOfView = 0;

  @override
  void initState() {
    super.initState();
    _user.username = "Username";
    getUsername();
    postIsLiked();
    infoOnPost();
  }

  String displayedDate() {
    var difference = "N/A";
    var daysDifference = DateTime.now().difference(widget.post.createdAt).inDays;
    if(daysDifference == 0){
      var hoursDifference =  DateTime.now().difference(widget.post.createdAt).inHours;
      if (hoursDifference < 1){
        var minutesDifference = DateTime.now().difference(widget.post.createdAt).inMinutes;
        if(minutesDifference > 1){
          difference = minutesDifference.toString() + "min";
        } else {
          difference = DateTime.now().difference(widget.post.createdAt).inSeconds.toString() + "sec";
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
    final response = await http.get(Uri.parse('https://user.mignon.chat/user/${widget.post.uidUser}'),
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

  void postIsLiked() async {
    final response = await http.get(Uri.parse('https://react.mignon.chat/${widget.post.uid}/like/${AuthenticateService.uidUser}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthenticateService.token}',
        }
    );
    if(response.statusCode == 200){
      var like = jsonDecode(response.body);
      this.setState(() {
        _postIsLiked = like == 1 ? true : false;
      });
    }
  }

  void likePost() async {
    if(_postIsLiked){
      final response = await http.delete(Uri.parse('https://react.mignon.chat/${widget.post.uid}/like/${AuthenticateService.uidUser}'));
    } else {
      final response = await http.post(Uri.parse('https://react.mignon.chat/${widget.post.uid}/like/${AuthenticateService.uidUser}'));
    }
    postIsLiked();
    infoOnPost();
  }

  void infoOnPost() async {
    final response = await http.get(Uri.parse('https://react.mignon.chat/${widget.post.uid}'));
    if(response.statusCode == 200){
      var statut = jsonDecode(response.body);
      this.setState(() {
        _numberOfLike = statut["like"];
        _numberOfView = statut["view"];
      });
    }
  }

  void _respondPost() {
    Navigator.pushNamed(context, '/respond_post', arguments: CommentArgument(widget.post.uid, _user.fullname));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text("${_user.fullname} - ${displayedDate()}"),
              subtitle: Text(widget.post.text, style: TextStyle(fontSize: 20)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Icon(Icons.message),
                  onPressed: _respondPost,
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: _postIsLiked ? Icon(Icons.favorite, color: Colors.pink) : Icon(Icons.favorite_border),
                  onPressed: likePost,
                ),
                Text(_numberOfLike.toString()),
                const SizedBox(width: 8),
                TextButton(
                  child: Icon(Icons.remove_red_eye),
                  onPressed: () {},
                ),
                Text(_numberOfView.toString()),
                const SizedBox(width: 8),
                TextButton(
                  child: Icon(Icons.share),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      )
    );
  }
}