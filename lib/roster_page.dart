import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design/app_colors.dart';

class RosterPage extends StatefulWidget {
  String id;

  RosterPage({this.id});
  @override
  _RosterPageState createState() => _RosterPageState();
}

class _RosterPageState extends State<RosterPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Nuestros Jugadores',
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600)),
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 8.0),
        Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('players').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        children: snapshot.data.documents
                            .map<Widget>((doc) => BuildItem(doc))
                            .toList());
                  } else {
                    return SizedBox();
                  }
                }))
      ])
    ]));
  }
}

class AddButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  AddButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
            onTap: onPressed,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                decoration: BoxDecoration(
                    color: AppColors.amberCanes,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        text,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        )),
                      ),
                      Icon(Icons.add, color: Colors.white)
                    ]))));
  }
}

BuildItem(DocumentSnapshot doc) {
  return GestureDetector(
      onTap: () => print(doc.data['uid']),
      child: Column(children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
                color: AppColors.amberCanes.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 110,
                height: 90,
                decoration: BoxDecoration(
                    color: AppColors.amberCanes,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Image.network(
                      doc.data['photoUrl'],
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(width: 8.0),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      '${doc.data['first_name']} ${doc.data['last_name']}',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: AppColors.amberCanes,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Dorsal: ',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400)),
                          children: [
                            TextSpan(
                              text: doc.data['player_number'],
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: AppColors.amberCanes,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ]),
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Posición : ',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400)),
                            children: [
                          TextSpan(
                            text: doc.data['player_position'],
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: AppColors.amberCanes,
                                    fontWeight: FontWeight.w400)),
                          )
                        ]))
                  ])
            ])),
        SizedBox(height: 8.0)
      ]));
}
