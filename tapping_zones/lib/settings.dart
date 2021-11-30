import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Settings();
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController textFieldController = TextEditingController();
  String left = "Left";
  String right = "Right";
  String? _hand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Settings')),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: const Text('Left Hand'),
              leading: Radio<String>(
                  value: left,
                  groupValue: _hand,
                  onChanged: (String? value) {
                    setState(() {
                      _hand = value;
                    });
                  }),
            ),
            ListTile(
              title: const Text('Right Hand'),
              leading: Radio<String>(
                  value: right,
                  groupValue: _hand,
                  onChanged: (String? value) {
                    setState(() {
                      _hand = value;
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: TextField(
                controller: textFieldController,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
            RaisedButton(
              child: Text(
                'Done',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                _sendDataBack(context);
              },
            ),
          ]),
    );
  }

  void _sendDataBack(BuildContext context) {
    String textToSendBack = textFieldController.text;
    Navigator.pop(context, textToSendBack);
  }
}
