import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design/app_colors.dart';

class NewsDetail extends StatefulWidget {
  NewsDetail({Key key, this.title}) : super(key: key);
  final DocumentSnapshot title;
  static String tag = 'detailsNew-page';

  @override
  _NewsDetailState createState() => new _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.darkGrey,
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              Container(
                color: AppColors.amberCanes,
                margin: const EdgeInsets.all(10.0),
                child: Image.network(
                  widget.title.data['news_img'],
                  width: 500.0,
                  height: 250.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                widget.title.data['news_title'],
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: AppColors.amberCanes,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  SizedBox(width: 10.0),
                  Text(
                    widget.title.data['news_date'],
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: AppColors.lightGrey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(10.0),
                child: Text(
                  widget.title.data['N_Details'],
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w200)),
                ),
              )
            ],
          ),
        )));
  }
}
