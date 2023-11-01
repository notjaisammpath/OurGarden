import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourgarden/backend/trefleBackend.dart';
import 'package:ourgarden/pages/AddPlantPage.dart';
import 'package:ourgarden/pages/HomePage.dart';
import 'package:ourgarden/pages/MyAccountPage.dart';
import 'package:ourgarden/backend/user.dart';
import 'package:ourgarden/pages/MyGardenPageWidgets/plantview.dart';
import 'package:provider/provider.dart';
import 'package:ourgarden/backend/back4appBackend.dart';

import 'backend/plant.dart';
import 'pages/NewPostPage.dart';

void main() {
  runApp(
    MainApp(),
  );
  Back4AppBackend().initParse();
}

class MainApp extends StatelessWidget {
  static var materialApp = MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'OurGarden',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 58, 116, 71)),
    ),
    home: SignUpPage(),
  );
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(), child: materialApp);
  }
}

class MyAppState extends ChangeNotifier {
  var currentUser = User();
  var authenticated = false;
  bool hasProfilePicture = false;
  bool setAuthenticated(bool auth) {
    authenticated = auth;
    return authenticated;
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //create a login page
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          Container(
            height: 150.0,
            width: 190.0,
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(300),
            ),
            child: Center(
              child: Icon(
                Icons.account_circle_rounded,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid mail id as abc@gmail.com'),
              onChanged: (value) =>
                  context.watch<MyAppState>().currentUser.setDisplayName(value),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your secure password'),
            ),
          ),
          SizedBox(
            height: 50,
            width: 250,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.surfaceVariant)),
              onPressed: () {
                Back4AppBackend().createAccount(
                  Provider.of<MyAppState>(context, listen: false).currentUser,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavBarPages(),
                  ),
                );
              },
              child:
                  Text('Log In', style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ForgotPasswordPage(),
                  ),
                );
              },
              child: Text(
                'Forgot Password',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateProfilePage extends StatefulWidget {
  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
      ),
      body: Column(
        children: [
          Container(
            height: 150.0,
            width: 190.0,
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(300),
            ),
            child: Center(
              child: Column(
                children: [
                  TextButton(
                    child: Text("Add a Profile Photo"),
                    onPressed: () => Placeholder(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              maxLength: 32,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Display Name',
              ),
              onChanged: (value) => print(
                  Provider.of<MyAppState>(context, listen: false)
                      .currentUser
                      .setDisplayName(value)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10)
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone Number (optional)',
              ),
              onChanged: (value) => print(
                  Provider.of<MyAppState>(context, listen: false)
                      .currentUser
                      .setPhoneNumber(int.parse(value))),
            ),
          ),
          SizedBox(
            height: 50,
            width: 250,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.surfaceVariant)),
              onPressed: () {
                Back4AppBackend().createAccount(
                    Provider.of<MyAppState>(context, listen: false)
                        .currentUser);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavBarPages(),
                  ),
                );
              },
              child: Text('Sign Up',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: 150.0,
            width: 190.0,
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(300),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Welcome to OurGarden",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter a valid email'),
              onChanged: (value) =>
                  Provider.of<MyAppState>(context, listen: false)
                      .currentUser
                      .setEmail(value),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your secure password'),
              onChanged: (value) =>
                  Provider.of<MyAppState>(context, listen: false)
                      .currentUser
                      .setPassword(value),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm your Password',
                  hintText: 'Confirm your secure password'),
              onSubmitted: (value) => {},
            ),
          ),
          SizedBox(
            height: 50,
            width: 250,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.surfaceVariant)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateProfilePage(),
                  ),
                );
              },
              child: Text('Sign Up',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(),
                  ),
                );
              },
              child: Text(
                "I've already signed up",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Forgot Password Page'),
      ),
    );
  }
}

class NavBarPages extends StatefulWidget {
  @override
  State<NavBarPages> createState() => _NavBarPagesState();
}

class _NavBarPagesState extends State<NavBarPages> {
  @override
  void initState() {
    super.initState();
  }

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        onGenerateRoute: generateRoute,
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
        navigatorKey.currentState?.pushReplacementNamed("Home");
        break;
      case 1:
        navigatorKey.currentState?.pushReplacementNamed("New Post");
        break;
      case 2:
        navigatorKey.currentState?.pushReplacementNamed("My Garden");
        break;
    }
    setState(() {
      _currentIndex = tabIndex;
    });
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "Home":
        return MaterialPageRoute(builder: (context) => HomePage());
      case "New Post":
        return MaterialPageRoute(builder: (context) => PostPage());
      case "My Garden":
        return MaterialPageRoute(builder: (context) => MyGardenPage());
      default:
        return MaterialPageRoute(builder: (context) => HomePage());
    }
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded),
          label: "New Post",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.yard_rounded),
          label: "My Garden",
        ),
      ],
      showSelectedLabels: true,
      showUnselectedLabels: false,
      currentIndex: _currentIndex,
      backgroundColor: MainApp.materialApp.theme?.colorScheme.surfaceVariant,
      onTap: _onTap,
    );
  }
}

class MyGardenPage extends StatefulWidget {
  @override
  State<MyGardenPage> createState() => _MyGardenPage();
}

class _MyGardenPage extends State<MyGardenPage> {
  static List<PlantView> garden = [];
  void fetchGarden() async {
    List<Plant> temp = [];
    temp = await trefleBackend()
        .getGarden(Provider.of<MyAppState>(context, listen: false).currentUser);
    garden = [];
    for (Plant k in temp) {
      int numPlants = 0;
      for (String y in Provider.of<MyAppState>(context, listen: false)
          .currentUser
          .gardenCommonNames) {
        if (k.data[0].commonName!.trim().toLowerCase() ==
            y.trim().toLowerCase()) {
          numPlants++;
        }
      }
      setState(() {
        garden.add(PlantView.fromPlant(k, numPlants));
      });
    }
  }

  @override
  void initState() {
    fetchGarden();
    super.initState();
  }

  List<Widget> generateGrid(BuildContext context) {
    List<Widget> finalList = <Widget>[
      ColoredBox(
          color: Theme.of(context).colorScheme.outlineVariant,
          child: TextButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_box_rounded),
                Text("Add a new plant"),
              ],
            ),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddPlantPage())),
          )),
    ];

    for (PlantView k in garden) {
      finalList.add(k);
    }
    return finalList;
  }

  @override
  Widget build(BuildContext context) {
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
                hintText: "Search in your garden",
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
      body: Column(
        children: [
          Expanded(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.background,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: garden.isEmpty
                    ? [
                        Text(r"There aren't any plants in your garden"),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPlantPage())),
                          child: Text("Add your first plant"),
                        )
                      ]
                    : [
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            children: generateGrid(context),
                          ),
                        ),
                      ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
