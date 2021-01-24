import 'package:canes_app/Fans/master_fan.dart';
import 'package:canes_app/utils/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

import 'add_details_player_screen.dart';
import 'login_screen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKeySign = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  String SelectedType;
  List<String> userType = ["Player", "Fan"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      height: MediaQuery.of(context).size.height,
      color: AppColors.darkGrey,
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: Form(
        key: _formKeySign,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Crear cuenta',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700)),
            ),
            SizedBox(height: 20.0),
            Container(
              child: TextFormField(
                validator: Validator.passValidator,
                controller: firstNameController,
                cursorColor: Colors.white,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white)),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                  hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white70)),
                  hintText: "Nombre",
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
                child: TextFormField(
                    validator: Validator.passValidator,
                    controller: lastNameController,
                    cursorColor: Colors.white,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.white)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                      hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white70)),
                      hintText: "Apellido",
                    ))),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextFormField(
                validator: Validator.mailValidator,
                controller: mailController,
                cursorColor: Colors.white,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white)),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.white,
                  ),
                  hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white70)),
                  hintText: "Email",
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              validator: Validator.passValidator,
              controller: passwordController,
              obscureText: true,
              cursorColor: Colors.white,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white)),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.white,
                ),
                hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white70)),
                hintText: "Password",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.amberCanes)),
                hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.white)),
                hintText: "Tipo de Usuario",
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
              ),
              value: SelectedType,
              onChanged: (String Value) {
                setState(() {
                  SelectedType = Value;
                });
              },
              items: userType.map((String user) {
                return DropdownMenuItem<String>(
                    value: user,
                    child: Text(user,
                        style: TextStyle(color: AppColors.amberCanes)));
              }).toList(),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
                onTap: () {
                  if (_formKeySign.currentState.validate()) {
                    _formKeySign.currentState.save();
                    VerifyUser(
                      context,
                      mailController.text.trim(),
                      passwordController.text.trim(),
                      SelectedType,
                    );
                  }
                },
                child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                        color: AppColors.amberCanes,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Center(
                        child: Text('Registro',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600)))))),
            SizedBox(height: 32.0),
            Container(
                height: 1.0, width: double.infinity, color: Colors.white30),
            SizedBox(height: 16.0),
            Text.rich(TextSpan(
                text: '¿ Ya tienes cuenta ? ',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)),
                children: [
                  TextSpan(
                    text: 'Login',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Login())),
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  )
                ]))
          ],
        ),
      ),
    )));
  }

  final db = Firestore.instance;
  Future<void> VerifyUser(
      BuildContext context, String mail, String password, String type) async {
    try {
      final FirebaseUser user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: mail, password: password))
          .user;

      if (user != null) {
        if (type == "player") {
          await db.collection('players').document(user.uid).setData({
            'first_name': firstNameController.text.trim(),
            'last_name': lastNameController.text.trim(),
            'email': mailController.text.trim(),
            'uid': user.uid,
            'user_type': 0,
          });
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddDetailsPlayer(id: user.uid)),
          );
        }
        if (type == "fan") {
          await db.collection('fans').document(user.uid).setData({
            'first_name': firstNameController.text.trim(),
            'last_name': lastNameController.text.trim(),
            'email': mailController.text.trim(),
            'uid': user.uid,
          });
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MasterFan(id: user.uid)),
          );
        }
        print("Hecho");
      }
    } catch (e) {
      print(e);
      print("Error");
    }
  }
}
