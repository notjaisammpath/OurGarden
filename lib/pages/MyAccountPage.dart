import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourgarden/backend/back4appBackend.dart';
import 'package:ourgarden/backend/user.dart';
import 'package:ourgarden/pages/AboutPage.dart';
import 'package:ourgarden/pages/myRequestsPage.dart';
import 'package:ourgarden/pages/post.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class MyAccountPage extends StatefulWidget {
  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  var hasPhoto = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<MyAppState>().currentUser;
    List<Widget> inColumn = [
      hasPhoto
          ? Placeholder()
          : IconButton(
              iconSize: 90,
              onPressed: () => addPhoto(context),
              icon: Icon(Icons.person_rounded),
            ),
      Padding(
        padding: EdgeInsets.only(top: 12),
        child: Text(
          textScaleFactor: 2,
          user.getDisplayName(),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 5, bottom: 12),
        child: Text(
          user.getEmail(),
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 20 / 7,
            children: [
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: ListTile(
                  leading: Icon(Icons.history_rounded),
                  title: Text(
                    "My Requests",
                    textScaleFactor: 1,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => myRequestsPage()),
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: ListTile(
                  leading: Icon(Icons.yard_rounded),
                  title: Text(
                    "My Garden",
                    textScaleFactor: 1,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyGardenPage()),
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: ListTile(
                  leading: Icon(Icons.edit_rounded),
                  title: Text(
                    "Edit Profile",
                    textScaleFactor: 1,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyGardenPage()),
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: ListTile(
                  leading: Icon(Icons.manage_accounts_rounded),
                  title: Text(
                    "Settings",
                    textScaleFactor: 1,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyGardenPage()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(20),
        child: TextButton(
          onPressed:
              //create a route to send navigator to an about page
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutPage()),
          ),
          child: Text('About'),
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        leading: BackButton(),
        centerTitle: true,
        title: Text("Your Account"),
      ),
      body: Column(children: inColumn),
    );
  }

  void addPhoto(BuildContext context) {
    print('added Photo');
  }
}
