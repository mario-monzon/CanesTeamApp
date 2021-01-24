import 'package:canes_app/news_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design/app_colors.dart';

class NewsPage extends StatefulWidget {
  String id;
  NewsPage({this.id});
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Noticias',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('news').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: snapshot.data.documents
                              .map<Widget>((doc) => BuildItem(doc, context))
                              .toList());
                    } else {
                      return Container();
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
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => NewsDetail(
                  title: doc,
                )),
      );
    },
    child: Card(
      child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10.0),
          child: Image.network(
            doc.data['news_img'],
            width: 500.0,
            height: 150.0,
          ),
        ),
        Column(
          children: [
            SizedBox(
              width: 30,
            ),
            Text(
              doc.data['news_title'],
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: AppColors.amberCanes,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 3.0),
            Container(
              color: AppColors.amberCanes,
              width: 30.0,
              height: 2.0,
            ),
            SizedBox(height: 3.0),
            Text(
              doc.data['news_date'],
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400)),
            ),
          ],
        ),
        SizedBox(height: 10.0),
      ]),
    ),
  );
}
