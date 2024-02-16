import 'package:flutter/material.dart';
import 'package:ourgarden/backend/back4appBackend.dart';
import 'package:ourgarden/main.dart';
import 'package:ourgarden/pages/HomePage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';

class JoinCommunityPage extends StatefulWidget {
  @override
  State<JoinCommunityPage> createState() => _JoinCommunityPageState();
}

class _JoinCommunityPageState extends State<JoinCommunityPage> {
  bool foundCommunity = false;
  ParseObject? community;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    foundCommunity
                        ? Text(
                            "Community found named ${community?.get("communityName")}")
                        : Padding(padding: EdgeInsets.all(0)),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter the Community\'s Code'),
                        onChanged: (value) => {
                          setState(
                              () => {community = null, foundCommunity = false})
                        },
                        onSubmitted: (value) => {getCommunity(value)},
                      ),
                    ),
                    ElevatedButton(
                      child: Text("Join the Community"),
                      onPressed: () => {
                        Provider.of<MyAppState>(context, listen: false)
                            .currentUser
                            .communities
                            .add(community!.get("communityName")),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomePage(),
                          ),
                        )
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getCommunity(String k) async {
    print("getting community right now");
    var commList = await Back4AppBackend().getCommunitiesFromCode(k);
    if ((commList).isNotEmpty) {
      setState(() {
        foundCommunity = true;
        community = commList[0];
      });
    }
  }
}
