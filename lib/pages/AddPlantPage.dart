// ignore: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ourgarden/backend/back4appBackend.dart';
import 'package:ourgarden/backend/trefleBackend.dart';
import 'package:ourgarden/main.dart';
import 'package:ourgarden/pages/MyGardenPageWidgets/plantview.dart';
import 'package:provider/provider.dart';

import '../backend/plant.dart';

class AddPlantPage extends StatefulWidget {
  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  bool nameSubmitted = false;
  Plant? p;
  int numToAdd = 0;

  TextEditingController plantNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add a Plant'),
      ),
      body: Column(
        children: [
          nameSubmitted
              ? FutureBuilder<Plant>(
                  future:
                      getPlant(), // a previously-obtained Future<String> or null
                  builder:
                      (BuildContext context, AsyncSnapshot<Plant> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      p = snapshot.data;

                      children = <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text("Plant found!"),
                        ),
                        Image.network(
                          snapshot.data!.data[0].imageUrl!,
                          scale: 4,
                        ),
                      ];
                    } else if (snapshot.hasError) {
                      children = <Widget>[
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Error: ${snapshot.error}'),
                        ),
                      ];
                    } else {
                      children = const <Widget>[
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Awaiting result...'),
                        ),
                      ];
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ),
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 10, right: 10),
                  child: Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      "Type the plant's name into the box below to find your plant"),
                ),
          Expanded(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.background,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: plantNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a plant name'),
                      onChanged: (value) => {
                        () => nameSubmitted = false,
                      },
                      onSubmitted: (value) => {
                        setState(
                          () => nameSubmitted = true,
                        )
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3)
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'How many do you want to add?'),
                      onChanged: (value) => {
                        () => numToAdd = int.parse(value),
                      },
                      onSubmitted: (value) => {
                        setState(
                          () => numToAdd = int.parse(value),
                        )
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => addPlant(numToAdd),
                      child: Text("done"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addPlant(int num) {
    if (p != null) {
      for (int i = 0; i < num; i++) {
        Provider.of<MyAppState>(context, listen: false)
            .currentUser
            .gardenCommonNames
            .insert(0, plantNameController.text);
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Plant Added")));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyGardenPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a valid plant name")));
    }
  }

  Future<Plant> getPlant() async {
    return (await trefleBackend()
        .getPlantList("common_name", plantNameController.text))[0];
  }
}
