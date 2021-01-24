import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Events.dart';
import '../design/app_colors.dart';
import '../login_screen.dart';
import '../news.dart';
import '../roster_page.dart';
import '../sponsor_screen.dart';

class MasterFan extends StatefulWidget {
  String id;
  MasterFan({this.id});
  @override
  _MasterFanState createState() => _MasterFanState();
}

class _MasterFanState extends State<MasterFan> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var tabs = [
      RosterPage(),
      EventsPage(),
      NewsPage(),
      SponsorsPage(id: widget.id)
    ];

    final _itemsList = [
      TabItem(icon: Icons.group, title: 'Roster'),
      TabItem(icon: Icons.event, title: 'Eventos'),
      TabItem(icon: Icons.assignment, title: 'Noticias'),
      TabItem(icon: Icons.star, title: 'Sponsors'),
    ];
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.darkGrey,
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.amber,
        color: Colors.black26,
        activeColor: Colors.black,
        style: TabStyle.flip,
        items: _itemsList,
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.amberCanes.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder(
                          stream: Firestore.instance
                              .collection('fans')
                              .document(widget.id)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                    color: AppColors.amberCanes,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          text: '              Nombre :    ',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400)),
                                          children: [
                                            TextSpan(
                                              text: snapshot.data['first_name'],
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ]),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          text: '              Apellido :    ',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400)),
                                          children: [
                                            TextSpan(
                                              text: snapshot.data['last_name'],
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ]),
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 8.0),
                                        Container(
                                          width: 1.0,
                                          height: 16.0,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8.0),
                                        GestureDetector(
                                          onTap: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Login()));
                                          },
                                          child: Center(
                                            child: Text(
                                              'Desconectarse',
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Container(
                                          width: 1.0,
                                          height: 16.0,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8.0),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 8.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                tabs[_selectedIndex],
              ],
            ),
          )),
    ));
  }
}
