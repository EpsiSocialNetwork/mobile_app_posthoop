import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Mobile App packages
import 'package:mobile_app_posthoop/services/authenticateService.dart';
import 'package:mobile_app_posthoop/models/post.dart';
import 'package:mobile_app_posthoop/widget/post.dart';

class PostList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PostList();
  }
}

class _PostList extends State<PostList> {
  List<Post> _posts = [];

  void _fetchUser() async {
    final response = await http.get(Uri.parse('https://post.mignon.chat/post'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthenticateService.token}',
        }
    );
    if(response.statusCode == 200){
      var list = jsonDecode(response.body);
      var listPosts  = List<Post>.from(list.map((i) => Post.fromJson(i)));
      listPosts.sort((a,b) => -a.createdAt.compareTo(b.createdAt));
      this.setState(() {
        _posts = listPosts;
      });
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
        : Center(child: CircularProgressIndicator());
  }

  Future<void> _getData() async {
    setState(() {
      _fetchUser();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return _buildList();
  }
}