import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

class News extends StatefulWidget {
  static String tag = 'News-page';
  @override
  _NewsState createState() => new _NewsState();
}

class _NewsState extends State<News> {
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    void DeleteNew(String id) async {
      Widget okButton = FlatButton(
        child: Text("SI ", style: TextStyle(color: AppColors.darkGrey)),
        onPressed: () async {
          // FirebaseUser = await FirebaseAuth.instance.ge
          await db.collection("News").document(id).delete().catchError((e) {
            print(e);
          });
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("  Borrar"),
        content: Text('¿ Quiere borrar esta noticia ?'),
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
        // color: Colors.white,
        child: ExpansionTile(
          leading: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              child: Icon(
                Icons.check,
                color: Colors.white,
              )),
          title: Text(
            doc.data['N_Tilte'],
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: AppColors.amberCanes,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ),
          trailing: Icon(Icons.add, color: AppColors.amberCanes),
          childrenPadding:
              EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 4),
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logocanes2.png',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        doc.data['N_Created'],
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: AppColors.amberCanes,
                                fontSize: 16,
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
                          onPressed: () => DeleteNew(doc.data['N_ID']))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Image.network(
                      doc.data['N_Image'],
                      height: 150,
                      width: 200,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      doc.data['N_Details'],
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                ],
              ),
            )
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
                  'Crear noticia',
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
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddNew()),
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
                  stream: Firestore.instance.collection('News').snapshots(),
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

class AddNew extends StatefulWidget {
  AddNew({Key key, this.title}) : super(key: key);
  final String title;
  static String tag = 'AddNew-page';

  @override
  _AddNewState createState() => new _AddNewState();
}

class _AddNewState extends State<AddNew> {
  final db = Firestore.instance;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();

  final _formNew = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.darkGrey,
        body: Container(
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
                      hintText: "Título",
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    maxLines: 5,
                    validator: _validator,
                    controller: desccontroller,
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
                      hintText: "Detalles",
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      AddPhoto(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                          color: _colup,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Center(
                        child: Text(
                          up,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      if (_formNew.currentState.validate()) {
                        _formNew.currentState.save();
                        AddNew(context, namecontroller.text.trim(),
                            desccontroller.text.trim(), _url);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                          color: _colupdate,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Center(
                        child: Text(
                          update,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  String up = "Subir una imagen";
  String update = "Añadir noticia";
  Color _colupdate = AppColors.amberCanes;
  String update2 = "Actualizar";
  Color _colupdate2 = AppColors.amberCanes;
  Color _colup = AppColors.amberCanes;
  String _url;
  AddPhoto(BuildContext context) async {
    _url = null;

    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    String fileName = basename(file.path);

    StorageReference _reference =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = _reference.putFile(file);
    setState(() {
      up = "Uploading ...";
    });
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String urlAdress = await _reference.getDownloadURL();

    setState(() {
      _url = urlAdress;
    });

    if (_url != urlAdress) {
      print("try again");
    } else {
      setState(() {
        up = "Uploaded ! ";

        _colup = Colors.green;
      });
    }
  }

  Future<void> AddNew(
      BuildContext context, String name, String desc, String photo) async {
    if (photo == null) {
      setState(() {
        up = "Por favor, suba una imagen";
        _colup = Colors.redAccent;
      });
    } else {
      try {
        var hey = await db.collection('News').add({
          'N_Tilte': name,
          'N_Details': desc,
          'N_Image': photo,
          'N_Created': DateTime.now().year.toString() +
              "-" +
              DateTime.now().month.toString() +
              "-" +
              DateTime.now().day.toString() +
              " " +
              DateTime.now().hour.toString() +
              ":" +
              DateTime.now().minute.toString(),
        });

        String id = hey.documentID;
        await db.collection('News').document(id).updateData({
          'N_ID': id,
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
}
