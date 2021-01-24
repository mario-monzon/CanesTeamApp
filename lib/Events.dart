import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design/app_colors.dart';

class EventsPage extends StatefulWidget {
  String id;

  EventsPage({this.id});
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Eventos',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('events').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: snapshot.data.documents
                              .map<Widget>((doc) => BuildItem(doc, context))
                              .toList());
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

BuildItem(DocumentSnapshot doc, BuildContext context) {
  return GestureDetector(
    child: Card(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 30.0),
              Text(
                doc.data['event_title'],
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: AppColors.amberCanes,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(width: 10.0),
            ],
          ),
          SizedBox(height: 5.0),
          Text(
            doc.data['event_date'] + "  " + doc.data['event_time'],
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400)),
          ),
          SizedBox(height: 5.0),
          Row(
            children: [
              SizedBox(width: 30.0),
              Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Detalles :  "),
                        Text(
                          doc.data['event_body'],
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400)),
                        )
                      ]))
            ],
          ),
          SizedBox(height: 10.0),
        ],
      ),
    ),
  );
}
