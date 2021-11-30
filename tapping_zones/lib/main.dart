import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter/gestures.dart';

import 'database.dart';
import 'settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List accelerometer;
  late List gyroscope;
  late double pitch;
  late double roll;
  final double defaultPadding = 5.0;
  final List<int> zoneColors = [
    0xFF7747b6,
    0xFFacd8da,
    0xFF184773,
    0xFF184773,
    0xFF1a68af,
    0xFF7747b6,
    0xFF7747b6,
    0xFFacd8da,
    0xFF184773,
    0xFF184773,
    0xFF1a68af,
    0xFF7747b6,
  ];
  int _tapped_zone = 0;
  late Database db;

  initialize() {
    db = Database();
    db.initiliaze();
  }

  createAlertDialog(BuildContext context) {
    TextEditingController customController = new TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Your Name?"),
            content: TextField(
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Submit"),
                onPressed: () {
                  Navigator.of(context).pop(customController.text.toString());
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((AccelerometerEvent e) {
      setState(() {
        accelerometer = <double>[e.x, e.y, e.z];
      });
    });

    gyroscopeEvents.listen((GyroscopeEvent e) {
      setState(() {
        gyroscope = <double>[e.x, e.y, e.z];
      });
    });

    initialize();
  }

  SimpleComplementaryFilter() {
    pitch = (gyroscope[0] / 50) * 0.01;
    roll = (gyroscope[1] / 50) * 0.01;
    double pitchAcc, rollAcc;

    pitchAcc = atan2(accelerometer[1], accelerometer[2]) * 180 / pi;
    pitch = pitch * 0.98 + pitchAcc * 0.02;

    rollAcc = atan2(accelerometer[0], accelerometer[2]) * 180 / pi;
    roll = roll * 0.98 + rollAcc * 0.02;
  }

  _onTapDown(TapDownDetails details, int index) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // print(details.localPosition);
    // print("tap down " +
    //     x.toString() +
    //     ", " +
    //     y.toString() +
    //     " -> " +
    //     accelerometer.toString() +
    //     " // " +
    //     gyroscope.toString());
    SimpleComplementaryFilter();
    db.create(accelerometer, gyroscope, x, y, pitch, roll, index);

    setState(() {
      _tapped_zone = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = [];
    menuItems.add(PopupMenuItem(
      value: 'Settings',
      child: Text('Settings'),
    ));

    var myGridView = GridView.builder(
      itemCount: zoneColors.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.7),
        mainAxisSpacing: 2.5,
        crossAxisSpacing: 2.5,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Card(
            elevation: 5.0,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Text(
                "Zone ${index}",
                style: const TextStyle(
                    color: Colors.white70, height: 5, fontSize: 20),
              ),
            ),
            color: Color(zoneColors[index]),
          ),
          onTapDown: (TapDownDetails details) => _onTapDown(details, index),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor Data with Zone"),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return menuItems.toList();
            },
            onSelected: (s) {
              if (s == 'Settings') {
                goToSettings(context);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: myGridView),
          Center(
            child: Text('Zone -> ${_tapped_zone}',
                style: TextStyle(
                  fontSize: 20,
                )),
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }

  void goToSettings(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }
}
