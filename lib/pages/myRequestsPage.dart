import 'package:flutter/material.dart';
import 'package:ourgarden/backend/back4appBackend.dart';
import 'package:ourgarden/backend/user.dart';
import 'package:ourgarden/main.dart';
import 'package:ourgarden/pages/NewPostPage.dart';
import 'package:ourgarden/pages/post.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';

class myRequestsPage extends StatefulWidget {
  @override
  State<myRequestsPage> createState() => _myRequestsPageState();
}

class _myRequestsPageState extends State<myRequestsPage> {
  List<Post> requests = [];

  @override
  void initState() {
    fetchPosts(Provider.of<MyAppState>(context, listen: false).currentUser);
    super.initState();
  }

  void fetchPosts(User u) async {
    List<Post> k =
        await Back4AppBackend().getPosts(User.justDisplayName("Jai Sammpath"));
    requests = [];
    setState(() {
      for (Post y in k) {
        if (y.type == PostType.request) {
          requests.add(y);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (requests.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: requests,
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            "You don't have any requests to fulfill",
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
