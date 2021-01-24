import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

class Sponsors extends StatefulWidget {
  static String tag = 'Sponsors-page';
  @override
  _SponsorsState createState() => new _SponsorsState();
}

class _SponsorsState extends State<Sponsors> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'No se puede abrir $url';
      }
    }

    void DeleteSponsor(String id) async {
      Widget okButton = FlatButton(
        child: Text(
          "Si ",
          style: TextStyle(color: AppColors.darkGrey),
        ),
        onPressed: () async {
          // FirebaseUser = await FirebaseAuth.instance.ge
          await db.collection("sponsor").document(id).delete().catchError((e) {
            print(e);
          });
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("  Borrar"),
        content: Text('¿ Quiere borrar este patrocinador ?'),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    BuildItem(DocumentSnapshot doc) {
      return Container(
        decoration: BoxDecoration(
            color: AppColors.amberCanes.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                  color: AppColors.amberCanes,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: AppColors.amberCanes,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Image.network(
                          doc.data['sponsor_logo'],
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            doc.data['sponsor_name'],
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  DeleteSponsor(doc.data['sponsor_id']))
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                            text: 'Web : ',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                            children: [
                              TextSpan(
                                text: doc.data['sponsor_web'],
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ]),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _launchURL(doc.data['sponsor_facebook']);
                            },
                            child: Center(
                              child: Text(
                                'Facebook',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 1,
                            height: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              _launchURL(doc.data['sponsor_instagram']);
                            },
                            child: Center(
                              child: Text(
                                'Instagram',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 1,
                            height: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              _launchURL(doc.data['sponsor_twitter']);
                            },
                            child: Center(
                              child: Text(
                                'Twitter',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                color: AppColors.amberCanes,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Añadir patrocinador',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600)),
                ),
                IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddSponsor()),
                      );
                    })
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('sponsors').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: snapshot.data.documents
                              .map<Widget>((doc) => BuildItem(doc))
                              .toList());
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class AddSponsor extends StatefulWidget {
  AddSponsor({Key key, this.title}) : super(key: key);
  final String title;
  static String tag = 'AddSponsor-page';

  @override
  _AddSponsorState createState() => new _AddSponsorState();
}

class _AddSponsorState extends State<AddSponsor> {
  final db = Firestore.instance;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController webcontroller = TextEditingController();
  TextEditingController fbcontroller = TextEditingController();
  TextEditingController inscontroller = TextEditingController();
  TextEditingController twitcontroller = TextEditingController();

  final _formNew = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.darkGrey,
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Form(
              key: _formNew,
              child: Column(
                children: [
                  SizedBox(height: 100),
                  TextFormField(
                    validator: _validator,
                    controller: namecontroller,
                    cursorColor: AppColors.amberCanes,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: AppColors.amberCanes)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: AppColors.amberCanes)),
                      hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white)),
                      hintText: "Titulo",
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: _UrlValidator,
                    controller: webcontroller,
                    cursorColor: AppColors.amberCanes,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: AppColors.amberCanes)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14.00),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: AppColors.amberCanes)),
                      hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white)),
                      hintText: "Web",
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    validator: _UrlValidator,
                    controller: fbcontroller,
                    cursorColor: AppColors.amberCanes,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: AppColors.amberCanes)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: AppColors.amberCanes)),
                      hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white)),
                      hintText: "Facebook",
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    validator: _UrlValidator,
                    controller: inscontroller,
                    cursorColor: AppColors.amberCanes,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: AppColors.amberCanes)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: AppColors.amberCanes)),
                      hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white)),
                      hintText: "Instagram",
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    validator: _UrlValidator,
                    controller: twitcontroller,
                    cursorColor: AppColors.amberCanes,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: AppColors.amberCanes)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: AppColors.amberCanes)),
                      hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white)),
                      hintText: "Twitter",
                    ),
                  ),
                  SizedBox(height: 15.0),
                  GestureDetector(
                    onTap: () {
                      AddPhoto(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                          color: _colup,
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      child: Center(
                        child: Text(
                          up,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      if (_formNew.currentState.validate()) {
                        _formNew.currentState.save();
                        AddSpons(
                            context,
                            namecontroller.text.trim(),
                            webcontroller.text.trim(),
                            fbcontroller.text.trim(),
                            inscontroller.text.trim(),
                            twitcontroller.text.trim(),
                            _url);
                      }
                      SnackBar(
                        content: Text(webcontroller.text.trim()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                          color: _colupdate,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Center(
                        child: Text(
                          update,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  String up = "Cargar logo";
  String update = "Añadir patrocinador";
  Color _colupdate = AppColors.amberCanes;
  String update2 = "Update";
  Color _colupdate2 = AppColors.amberCanes;
  Color _colup = AppColors.amberCanes;
  String _url;
  AddPhoto(BuildContext context) async {
    _url = null;

    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    String fileName = basename(file.path);

    StorageReference _reference =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = _reference.putFile(file);
    setState(() {
      up = "Subiendo ...";
    });
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String urlAdress = await _reference.getDownloadURL();

    setState(() {
      _url = urlAdress;
    });

    if (_url != urlAdress) {
      print("Intentelo de nuevo");
    } else {
      setState(() {
        up = "Subiendo ! ";

        _colup = Colors.green;
      });
    }
  }

  Future<void> AddSpons(BuildContext context, String name, String web,
      String fb, String insta, String twit, String photo) async {
    if (photo == null) {
      setState(() {
        up = 'Por favor, suba una imagen';
        _colup = Colors.redAccent;
      });
    } else {
      try {
        var hey = await db.collection('sponsor').add({
          'sponsor_name': name,
          'sponsor_web': web,
          'sponsor_instagram': insta,
          'sponsor_twitter': twit,
          'sponsor_logo': photo,
          'sponsor_facebook': fb
        });

        String id = hey.documentID;
        await db.collection('Sponsors').document(id).updateData({
          'S_ID': id,
        });

        setState(() {
          _colupdate = Colors.green;
          update = "Hecho";
        });
      } catch (e) {
        print(e);
        print("Error");
      }
    }
  }

  String _validator(String value) {
    if (value.length == 0)
      return 'Este campo es requerido';
    else
      return null;
  }

  String _UrlValidator(String value) {
    Pattern pattern =
        r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    RegExp regex = new RegExp(pattern);

    print('URL Value: $value - $regex');

    if (value.length != 0 && !regex.hasMatch(value))
      return 'Por favor, escriba una direccion válida';
    else
      return null;
  }
}
