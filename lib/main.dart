import 'package:flutter/material.dart';

import 'design/app_colors.dart';
import 'login_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Canes App ',
      theme: ThemeData(
        primaryColor: AppColors.amberCanes,
      ),
      home: Login(),
    );
  }
}
