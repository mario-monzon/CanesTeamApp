import 'package:canes_app/Events.dart';
import 'package:canes_app/Player/player_profile_screen.dart';
import 'package:canes_app/roster_page.dart';
import 'package:canes_app/sponsor_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

import 'manage_master.dart';

class AdminMaster extends StatefulWidget {
  String id;
  AdminMaster({this.id});
  @override
  _AdminMasterState createState() => _AdminMasterState();
}

class _AdminMasterState extends State<AdminMaster> {
  int bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    var tabs = [
      Profile(id: widget.id),
      RosterPage(),
      EventsPage(),
      SponsorsPage(
        id: widget.id,
      )
    ];
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.darkGrey,
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
            color: AppColors.amberCanes,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    bottomNavIndex = 0;
                  });
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color:
                            bottomNavIndex == 0 ? Colors.white : Colors.black54,
                      ),
                      Text(
                        'Home',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: bottomNavIndex == 0
                                    ? Colors.white
                                    : Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    bottomNavIndex = 1;
                  });
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color:
                            bottomNavIndex == 1 ? Colors.white : Colors.black54,
                      ),
                      Text(
                        'Roster',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: bottomNavIndex == 1
                                    ? Colors.white
                                    : Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    bottomNavIndex = 2;
                  });
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        color:
                            bottomNavIndex == 2 ? Colors.white : Colors.black54,
                      ),
                      Text(
                        'Eventos',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: bottomNavIndex == 2
                                    ? Colors.white
                                    : Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    bottomNavIndex = 3;
                  });
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_ind_outlined,
                        color:
                            bottomNavIndex == 3 ? Colors.white : Colors.black54,
                      ),
                      Text(
                        'Patrocinadores',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: bottomNavIndex == 4
                                    ? Colors.white
                                    : Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.amberCanes.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                            color: AppColors.amberCanes,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: StreamBuilder(
                            stream: Firestore.instance
                                .collection('Administrador')
                                .document(widget.id)
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Hola,' +
                                          " " +
                                          snapshot.data['first_name'],
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.settings,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ManageMaster(
                                                        id: widget.id)),
                                          );
                                        })
                                  ],
                                );
                              } else {
                                return Text(
                                  'Hola, ' + "",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600)),
                                );
                              }
                            }),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 8),
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
                tabs[bottomNavIndex],
              ],
            ),
          )),
    ));
  }
}
