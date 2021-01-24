import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

class MyOffersPage extends StatefulWidget {
  MyOffersPage({Key key, this.title}) : super(key: key);
  final String title;
  static String tag = 'MyOffersPage-page';
  @override
  _MyOffersPageState createState() => new _MyOffersPageState();
}

class _MyOffersPageState extends State<MyOffersPage> {
  final db = Firestore.instance;
  final DateTime now = DateTime.now();
  buildItemy(DocumentSnapshot doc) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            StreamBuilder(
                stream: Firestore.instance
                    .collection('Players')
                    .document(doc.data['ID_Player'])
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return RichText(
                      text: TextSpan(
                          text: 'Nombre : ',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          children: [
                            TextSpan(
                              text: snapshot.data['first_name'] +
                                  " " +
                                  snapshot.data['last_name'],
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: AppColors.amberCanes,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ]),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
          ],
        ));
  }

  buildItem(DocumentSnapshot doc) {
    DateTime tempDate = new DateFormat("dd-MM-yyyy hh:mm")
        .parse(doc.data['Date'] + " " + doc.data['Time']);
    if (doc.data['user'] == widget.title && now.isBefore(tempDate)) {
      return StreamBuilder(
          stream: Firestore.instance
              .collection('Players')
              .document(doc.data['user'])
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                      color: AppColors.amberCanes.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: ExpansionTile(
                      title: Row(
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
                              SizedBox(height: 8),
                              Text(
                                snapshot.data['first_name'] +
                                    " " +
                                    snapshot.data['last_name'],
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
                          )
                        ],
                      ),
                      children: [
                        Column(
                          children: <Widget>[
                            StreamBuilder<QuerySnapshot>(
                              stream: db
                                  .collection("CarSharing")
                                  .document(doc.data['Offer_ID'])
                                  .collection("Booking")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                      children: snapshot.data.documents
                                          .map<Widget>((doc) => buildItemy(doc))
                                          .toList());
                                } else {
                                  return SizedBox(
                                    height: 30,
                                    child: Text(
                                      "No se ha reservado aun",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ]));
            } else {
              return SizedBox();
            }
          });
    } else {
      return SizedBox();
    }
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
