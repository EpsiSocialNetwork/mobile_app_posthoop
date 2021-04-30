import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile_app_posthoop/models/follow.dart';
import 'package:mobile_app_posthoop/models/post.dart';

// Mobile App packages
import 'package:mobile_app_posthoop/models/user.dart';
import 'package:mobile_app_posthoop/services/authenticateService.dart';
import 'package:mobile_app_posthoop/widget/post.dart';

class UserInfoWidget extends StatefulWidget {
  UserInfoWidget({Key key}) : super(key: key);

@override
_UserInfoWidget createState() => _UserInfoWidget();
}

class _UserInfoWidget extends State<UserInfoWidget> {
  User _user = new User();
  bool dataWasLoaded = false;
  List<Follow> _followers = [];
  List<Follow> _followings = [];
  List<Post> _posts = [];
  bool isFirstBuid = true;
  bool isFollow = false;

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    _user.fullname = "Username";
    _user.username = "Username";
    _user.description = "Your description will apear here.";
    _user.createdAt = new DateTime.now();
  }

  void getUser() async {
    final response = await http.get(Uri.parse('https://user.mignon.chat/user/${_user.uid}'),
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

  void getFollowings() async {
    final response = await http.get(Uri.parse('https://user.mignon.chat/user/${_user.uid}/follow'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthenticateService.token}',
        }
    );
    if(response.statusCode == 200){
      var list = jsonDecode(response.body);
      var listFollowings  = List<Follow>.from(list.map((i) => Follow.fromJson(i)));
      this.setState(() {
        _followings = listFollowings;
      });
    }
  }

  void getFollowers() async {
    final response = await http.get(Uri.parse('https://user.mignon.chat/user/${_user.uid}/following'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthenticateService.token}',
        }
    );

    if(response.statusCode == 200){
      var list = jsonDecode(response.body);
      var listFollowings  = List<Follow>.from(list.map((i) => Follow.fromJson(i)));
      var _isFollow = listFollowings.where((follow) => follow.uidUser == AuthenticateService.uidUser).length >= 1 ? true : false;
      this.setState(() {
        isFollow = _isFollow;
        _followers = listFollowings;
      });
    }
  }

  void getPosts() async {
    final response = await http.get(Uri.parse('https://post.mignon.chat/post/timeline/user?uids=${_user.uid}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthenticateService.token}',
        }
    );
    if(response.statusCode == 200){
      if(response.body.isNotEmpty){
        var list = jsonDecode(response.body);
        var listPosts  = List<Post>.from(list.map((i) => Post.fromJson(i)));
        listPosts.sort((a,b) => -a.createdAt.compareTo(b.createdAt));
        this.setState(() {
          _posts = listPosts;
        });
        dataWasLoaded = true;
      }
    }
  }

  void _follow() async {
    if(isFollow){
      final response = await http.delete(Uri.parse('https://user.mignon.chat/follow'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${AuthenticateService.token}',
          },
          body: jsonEncode({
            'uidUser': AuthenticateService.uidUser,
            'followUidUser': _user.uid
          })
      );
      this.setState(() {
        isFollow = false;
      });
      getFollowers();
    } else {
      final response = await http.post(Uri.parse('https://user.mignon.chat/follow'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${AuthenticateService.token}',
          },
          body: jsonEncode({
            'uidUser': AuthenticateService.uidUser,
            'followUidUser': _user.uid
          })
      );
      if(response.statusCode == 201){
        getFollowers();
        this.setState(() {
          isFollow = true;
        });
      }
    }
  }

  void _viewPost(Post post) {
    Navigator.pushNamed(context, '/post', arguments: post);
  }

  Widget _buildList() {
    return _posts.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
                itemCount: _posts.length,
                itemBuilder: (BuildContext context, int index) {
            return PostWidget(
              post: _posts[index],
              onPressed:() => _viewPost(_posts[index]),
            );
          }
      ),
      onRefresh: _getData,
    )
    : dataWasLoaded ? Text("No Post on this account") : Center(child: CircularProgressIndicator());
  }

  Future<void> _getData() async {
    setState(() {
      getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final User _userFromPost = ModalRoute.of(context).settings.arguments;
    final height = MediaQuery.of(context).size.height;

    this.setState(() {
      _user = _userFromPost;
    });

    if(isFirstBuid){
      getPosts();
      getFollowings();
      getFollowers();
      isFirstBuid = false;
    }

    return Scaffold(
        body: Container(
          height: height,
          child: Column(
            children: <Widget>[
              SizedBox(height: height * .05),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                    child: Icon(Icons.close),
                    onPressed: () {Navigator.pop(context);},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        _user.username,
                        style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        ),
                      ),
                      Text(
                        "@${_user.fullname}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )
                      )
                    ]
                  ),
                  TextButton(
                    child: isFollow ? Text("Follower") : Text("Subscribe"),
                    onPressed: _follow,
                  ),
                ],
              ),
              Text(_user.description),
              Text("Member from ${months[_user.createdAt.month - 1]} ${_user.createdAt.year}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("${_followings.length} followings"),
                  Text("${_followers.length} followers")
                ],
              ),
              SizedBox(height: height * .05),
              Container(
                height: 500,
                child:  _buildList()
              )
            ],
        )
      )
    );
  }
}