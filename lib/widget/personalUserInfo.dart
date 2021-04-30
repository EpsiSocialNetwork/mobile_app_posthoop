import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile_app_posthoop/models/follow.dart';
import 'package:mobile_app_posthoop/models/post.dart';

// Mobile App packages
import 'package:mobile_app_posthoop/models/user.dart';
import 'package:mobile_app_posthoop/services/authenticateService.dart';
import 'package:mobile_app_posthoop/widget/post.dart';

class PersonalUserInfoWidget extends StatefulWidget {
  PersonalUserInfoWidget({Key key}) : super(key: key);

  @override
  _PersonalUserInfoWidget createState() => _PersonalUserInfoWidget();
}

class _PersonalUserInfoWidget extends State<PersonalUserInfoWidget> {

  User _user = new User();
  bool dataWasLoaded = false;
  List<Follow> _followers = [];
  List<Follow> _followings = [];
  List<Post> _posts = [];

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
    getUser();
    getPersonalsPosts();
    getFollowings();
    getFollowers();
  }

  void getUser() async {
    final response = await http.get(Uri.parse('https://user.mignon.chat/user/${AuthenticateService.uidUser}'),
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
    final response = await http.get(Uri.parse('https://user.mignon.chat/user/${AuthenticateService.uidUser}/follow'),
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
    final response = await http.get(Uri.parse('https://user.mignon.chat/user/${AuthenticateService.uidUser}/following'),
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
        _followers = listFollowings;
      });
    }
  }

  void getPersonalsPosts() async {
    final response = await http.get(Uri.parse('https://post.mignon.chat/post/timeline/user?uids=${AuthenticateService.uidUser}'),
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

  void _follow(){

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
      getPersonalsPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
            height: height,
            child: Column(
              children: <Widget>[
                SizedBox(height: height * .05),
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