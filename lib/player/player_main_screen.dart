import 'package:canes_app/Events.dart';
import 'package:canes_app/admin/manage_master.dart';
import 'package:canes_app/login_screen.dart';
import 'package:canes_app/news.dart';
import 'package:canes_app/player/car_sharing_screen.dart';
import 'package:canes_app/roster_page.dart';
import 'package:canes_app/sponsor_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

class Master extends StatefulWidget {
  String id;

  Master({this.id});
  @override
  _MasterState createState() => _MasterState();
}

class _MasterState extends State<Master> {
  int bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 2;

    var tabs = [
      RosterPage(id: widget.id),
      EventsPage(),
      NewsPage(id: widget.id),
      CarSharing(title: widget.id),
      SponsorsPage(id: widget.id)
    ];

    final _itemsList = [
      TabItem(icon: Icons.group, title: 'Roster'),
      TabItem(icon: Icons.event, title: 'Eventos'),
      TabItem(icon: Icons.assignment, title: 'Noticias'),
      TabItem(icon: Icons.car_rental, title: 'Transporte'),
      TabItem(icon: Icons.star, title: 'Sponsors'),
      // TabItem(icon: Icons.alternate_email, title: 'Contacto'),
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
                      StreamBuilder(
                          stream: Firestore.instance
                              .collection('players')
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 90.0,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          color: AppColors.amberCanes,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          child:
                                              snapshot.data['photoUrl'] == null
                                                  ? Image.network(
                                                      "https://cdn.icon-icons.com/icons2/510/PNG/512/person_icon-icons.com_50075.png",
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      snapshot.data['photoUrl'],
                                                      fit: BoxFit.cover,
                                                    )),
                                    ),
                                    SizedBox(width: 8.0),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${snapshot.data['first_name']} ${snapshot.data['last_name']}',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              text: 'Número: ',
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              children: [
                                                TextSpan(
                                                  text: snapshot
                                                      .data['player_number'],
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
                                              text: 'Posición : ',
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              children: [
                                                TextSpan(
                                                  text: snapshot
                                                      .data['player_position'],
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ),
                                              ]),
                                        ),
                                        SizedBox(height: 8.0),
                                      ],
                                    ),
                                    SizedBox(width: 7.5),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        snapshot.data['user_type'] != 0
                                            ? IconButton(
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
                                                              id: widget.id,
                                                              user_type: snapshot
                                                                  .data[
                                                                      'user_type']
                                                                  .toString(),
                                                            )),
                                                  );
                                                })
                                            : SizedBox(),
                                        SizedBox(height: 30.0),
                                        IconButton(
                                          icon: Icon(Icons.logout,
                                              color: Colors.white, size: 28.0),
                                          onPressed: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Login()));
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
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
