import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

class AllOffersPage extends StatefulWidget {
  AllOffersPage({Key key, this.title}) : super(key: key);
  final String title;
  static String tag = 'AllOffersPage-page';

  @override
  _AllOffersPageState createState() => new _AllOffersPageState();
}

class _AllOffersPageState extends State<AllOffersPage> {
  final db = Firestore.instance;
  final DateTime now = DateTime.now();
  String booki = "Book";

  buildItem(DocumentSnapshot doc) {
    DateTime tempDate = new DateFormat("dd-MM-yyyy hh:mm")
        .parse(doc.data['Date'] + " " + doc.data['Time']);
    if (int.parse(doc.data['S_Available']) - doc.data['S_Booked'] > 0 &&
        now.isBefore(tempDate)) {
      return StreamBuilder(
          stream: Firestore.instance
              .collection('Players')
              .document(doc.data['user'])
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          color: AppColors.amberCanes.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 110,
                              height: 90,
                              decoration: BoxDecoration(
                                  color: AppColors.amberCanes,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  child: snapshot.data['Photo'] == null
                                      ? Image.network(
                                          "https://cdn.icon-icons.com/icons2/510/PNG/512/person_icon-icons.com_50075.png",
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          snapshot.data['Photo'],
                                          fit: BoxFit.cover,
                                        )),
                            ),
                            SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data['first_name'],
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: AppColors.amberCanes,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: 'Fecha ',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                      children: [
                                        TextSpan(
                                          text: doc.data['Date'],
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: AppColors.amberCanes,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ]),
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: 'Hora : ',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                      children: [
                                        TextSpan(
                                          text: doc.data['Time'],
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: AppColors.amberCanes,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ]),
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: 'Asientos disponibles : ',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400)),
                                      children: [
                                        TextSpan(
                                          text: (int.parse(
                                                      doc.data['S_Available']) -
                                                  doc.data['S_Booked'])
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: AppColors.amberCanes,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            doc.data['user'] == widget.title
                                ? SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      var userQuery = db
                                          .collection("CarSharing")
                                          .document(doc.data['Offer_ID'])
                                          .collection("Booking")
                                          .where('ID_Player',
                                              isEqualTo: widget.title)
                                          .limit(1);

                                      userQuery
                                          .getDocuments()
                                          .then((data) async {
                                        if (data.documents.length == 0) {
                                          BookOffer(
                                              doc.data['Offer_ID'],
                                              doc.data['S_Booked'],
                                              snapshot.data['first_name']);
                                        } else {
                                          setState(() {
                                            booki = '¡Listo!';
                                          });
                                          print("si");
                                        }
                                      });
                                    },
                                    child: Center(
                                        child: Text(
                                      booki,
                                      maxLines: 2,
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                    ))),
                          ])),
                  SizedBox(height: 8)
                ],
              );
            } else {
              return SizedBox();
            }
          });
    } else {
      return SizedBox();
    }
  }

  void BookOffer(String id, int b, String name) async {
    Widget okButton = FlatButton(
      child: Text(
        "Si ",
        style: TextStyle(color: AppColors.darkGrey),
      ),
      onPressed: () async {
        await db.collection("CarSharing").document(id).updateData({
          'S_Booked': b + 1,
        });

        await db
            .collection("CarSharing")
            .document(id)
            .collection("Booking")
            .add({
          'ID_Player': widget.title,
        }).catchError((e) {
          print(e);
        });

        setState(() {
          booki = "Booked";
        });

        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("  Reserva un asiento con " + name),
      content: Text('¿ Realmente quieres reservar este asiento ?'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: db.collection("CarSharing").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: snapshot.data.documents
                        .map<Widget>((doc) => buildItem(doc))
                        .toList());
              } else {
                return SizedBox(height: 200);
              }
            },
          ),
        ],
      ),
    );
  }
}
