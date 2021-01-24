import 'dart:io';

import 'package:canes_app/text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

import 'Player/player_main_screen.dart';

class AddDetailsPlayer extends StatefulWidget {
  String id;

  AddDetailsPlayer({this.id});
  @override
  _AddDetailsPlayerState createState() => _AddDetailsPlayerState();
}

//TODO: Eleminar codigo comentado
class _AddDetailsPlayerState extends State<AddDetailsPlayer> {
  TextEditingController numcontroller = TextEditingController();
  // TextEditingController adresscontroller = TextEditingController();
  // TextEditingController phonecontroller = TextEditingController();
  TextEditingController positioncontroller = TextEditingController();

  Color _col2 = Colors.red;
  Color _col1 = Colors.red;
  String up = "Upload Personal Photo";
  String update = "Update";
  Color _colupdate = AppColors.amberCanes;
  String update2 = "Update";
  Color _colupdate2 = AppColors.amberCanes;
  Color _colup = AppColors.amberCanes;
  final _formFacilityKey = GlobalKey<FormState>();
  final _formPlayKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.amberCanes,
              title: Text('Add Details',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.w600))),
            ),
            body: Container(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 16,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.all(
                              color: Colors.black.withOpacity(0.15),
                              width: 0.5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5.0,
                                offset: Offset(0, 2))
                          ]),
                      child: ExpansionTile(
                        leading: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: _col2),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            )),
                        title: Text(
                          'Añadir más información',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: AppColors.amberCanes,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600)),
                        ),
                        trailing: Icon(Icons.add, color: AppColors.amberCanes),
                        childrenPadding: EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 12.0, top: 4.0),
                        children: [
                          Container(
                              child: Form(
                            key: _formPlayKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MyTextField('Número', numcontroller,
                                      TextInputType.number),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MyTextField('Posición',
                                      positioncontroller, TextInputType.text),
                                ),
                                // MyTextField('Teléfono', phonecontroller,
                                //     TextInputType.text),
                                // MyTextField('Dirección', adresscontroller,
                                //     TextInputType.streetAddress),
                                SizedBox(height: 8),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0))),
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
                                    if (_formPlayKey.currentState.validate()) {
                                      _formPlayKey.currentState.save();
                                      AddAllInfo(
                                          context,
                                          // phonecontroller.text.trim(),
                                          // adresscontroller.text.trim(),
                                          widget.id,
                                          _url,
                                          numcontroller.text.trim(),
                                          positioncontroller.text.trim());
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                    decoration: BoxDecoration(
                                        color: _colupdate2,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                      child: Text(
                                        update2,
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
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  final db = Firestore.instance;
  Future<void> AddAllInfo(
    BuildContext context,
    // String phone,
    // String adress,
    String user,
    String url,
    String num,
    String position,
  ) async {
    if (url == null) {
      setState(() {
        up = "Añada una foto";
        _colup = Colors.redAccent;
      });
    } else {
      try {
        await db.collection('players').document(user).updateData({
          // 'Address': adress,
          // 'Phone': phone,
          'photoUrl': url,
          'player_number': num,
          'player_position': position,
        });

        setState(() {
          _col2 = Colors.green;
          _colupdate2 = Colors.green;
          update2 = "Hecho";
          _col1 = Colors.green;
          _colupdate = Colors.green;
          update = "Hecho";
        });

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Master(id: widget.id)),
        );
      } catch (e) {
        print(e);
      }
    }
  }

  String _url;
  bool _loading = false;
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
      _loading = true;
      up = "Cargando ...";
    });
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String urlAdress = await _reference.getDownloadURL();

    setState(() {
      _url = urlAdress;
    });

    if (_url != urlAdress) {
      print("Intentar otra vez");
    } else {
      setState(() {
        _loading = false;
        up = "¡ Cargado !";
        _colup = Colors.green;
      });
    }
  }
}
