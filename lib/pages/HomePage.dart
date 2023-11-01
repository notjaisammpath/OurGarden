import 'package:flutter/material.dart';
import 'package:ourgarden/backend/back4appBackend.dart';
import 'package:ourgarden/backend/user.dart';
import 'package:ourgarden/main.dart';
import 'package:ourgarden/pages/post.dart';
import 'package:provider/provider.dart';

import 'CreateCommunityPage.dart';
import 'MyAccountPage.dart';
import 'JoinCommunityPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<Widget> posts = [];
  bool postsFetched = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> getFinalPostList(User u) async {
    var temp = await Back4AppBackend().getPosts(u);
    posts = [];
    for (Post k in temp) {
      setState(() {
        posts.add(k);
      });
    }
    postsFetched = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!postsFetched) {
      getFinalPostList(context.watch<MyAppState>().currentUser);
    }
    if (Provider.of<MyAppState>(context).currentUser.communities.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width * 4 / 5,
          leading: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 4 / 5),
            child: Padding(
              padding: EdgeInsets.only(bottom: 10, top: 5, left: 10, right: 10),
              child: TextField(
                textAlignVertical: TextAlignVertical(y: 1),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Search in your Community",
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyAccountPage(),
                  )),
              icon: Icon(Icons.account_circle_rounded),
              iconSize: 35,
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(r"You haven't joined any communities yet")),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JoinCommunityPage())),
                  child: Text("Join your first community"),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateCommunityPage())),
                child: Text("Create a community"),
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width * 4 / 5,
          leading: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 4 / 5),
            child: Padding(
              padding: EdgeInsets.only(bottom: 10, top: 5, left: 10, right: 10),
              child: TextField(
                textAlignVertical: TextAlignVertical(y: 1),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Search in your Community",
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyAccountPage(),
                  )),
              icon: Icon(Icons.account_circle_rounded),
              iconSize: 35,
            )
          ],
        ),
        body: posts.isNotEmpty
            ? ListView(
                shrinkWrap: true,
                children: posts,
              )
            : ColoredBox(
                color: Theme.of(context).splashColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                        "You don't have any posts to view"),
                  ),
                ),
              ),
      );
    }
  }
}
