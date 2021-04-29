import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Mobile App packages
import 'package:mobile_app_posthoop/services/authenticateService.dart';
import 'package:mobile_app_posthoop/models/comment.dart';
import 'package:mobile_app_posthoop/widget/comment.dart';

class CommentList extends StatefulWidget {
  CommentList({Key key, String this.uidPost}) : super(key: key);

  final String uidPost;

  @override
  State<StatefulWidget> createState() {
    return _CommentList();
  }
}

class _CommentList extends State<CommentList> {
  List<Comment> _comments = [];
  bool dataWasLoaded = false;

  void _fetchUser() async {
    final response = await http.get(Uri.parse('https://post.mignon.chat/post/${widget.uidPost}/comment'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthenticateService.token}',
        }
    );
    if(response.statusCode == 200){
      this.setState(() {
        var list = jsonDecode(response.body);
        var listComments  = List<Comment>.from(list.map((i) => Comment.fromJson(i)));
        listComments.sort((a,b) => -a.createdAt.compareTo(b.createdAt));
        _comments = listComments;
      });
      dataWasLoaded = true;
    }
  }

  Widget _buildList() {
    return _comments.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              itemCount: _comments.length,
              itemBuilder: (BuildContext context, int index) {
                return CommentWidget(
                  comment: _comments[index]
                );
              }
            ),
            onRefresh: _getData,
        )
        : dataWasLoaded ? Text("No Comments on this post") : Center(child: CircularProgressIndicator());
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