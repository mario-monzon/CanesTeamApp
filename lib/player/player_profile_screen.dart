import 'package:flutter/material.dart';

import '../news.dart';

class Profile extends StatefulWidget {
  String id;

  Profile({this.id});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: NewsPage(),
    );
  }
}

class AddButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  AddButton(this.text, this.onPressed);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RaisedButton(
        onPressed: onPressed,
        child: Row(
          children: [Icon(Icons.add), Expanded(child: Text(text))],
        ),
      ),
    );
  }
}
