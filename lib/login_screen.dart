import 'package:canes_app/utils/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Fans/master_fan.dart';
import 'Player/player_main_screen.dart';
import 'design/app_colors.dart';
import 'forgetpassword.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  final db = Firestore.instance;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  initState() {
    super.initState();
    Check();
  }

  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKeyLog = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.darkGrey,
            body: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Form(
                key: _formKeyLog,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'hero',
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 70.0,
                        child: Image.asset('assets/logocanes2.png',
                            fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: TextFormField(
                        validator: Validator.passValidator,
                        controller: passwordController,
                        obscureText: true,
                        cursorColor: Colors.white,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white)),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(14.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
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
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        if (_formKeyLog.currentState.validate()) {
                          _formKeyLog.currentState.save();
                          VerifyUser(context, mailController.text.trim(),
                              passwordController.text.trim());
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                            color: AppColors.amberCanes,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ForgotPassword()));
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Recuperar Contraseña?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Container(
                        height: 1.0,
                        width: double.infinity,
                        color: Colors.white30),
                    SizedBox(height: 16.0),
                    Text.rich(TextSpan(
                        text: '¿ No tienes contraseña ? ',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal)),
                        children: [
                          TextSpan(
                            text: 'Registrarse',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => SignUp())),
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          )
                        ]))
                  ],
                ),
              ),
            )));
  }

  final db = Firestore.instance;
  Future<void> VerifyUser(
      BuildContext context, String email, String password) async {
    try {
      final FirebaseUser user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
              .user;
      if (user != null) {
        //TODO: DocumentSnapshot snapshot2
        DocumentSnapshot snapshotPlayers =
            await db.collection('players').document(user.uid).get();
        //TODO: DocumentSnapshot snapshot3
        DocumentSnapshot snapshotFans =
            await db.collection('fans').document(user.uid).get();
        if (snapshotPlayers.exists) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Master(id: user.uid)),
          );
        }
        if (snapshotFans.exists) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MasterFan(id: user.uid)),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Check() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      DocumentSnapshot snapshotPlayers =
          await db.collection('players').document(user.uid).get();
      DocumentSnapshot snapshotFans =
          await db.collection('fans').document(user.uid).get();

      if (snapshotPlayers.exists) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Master(id: user.uid)));
      }
      if (snapshotFans.exists) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MasterFan(id: user.uid)));
      }
    }
  }
}
