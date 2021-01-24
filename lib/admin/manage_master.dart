import 'package:canes_app/admin/events_admin_screen.dart';
import 'package:canes_app/admin/sponsors_admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

import 'Admins.dart';
import 'news_admin_screen.dart';
import 'users_admin_screen.dart';

class ManageMaster extends StatefulWidget {
  String id;
  String user_type;

  ManageMaster({this.id, this.user_type});
  @override
  _ManageMasterState createState() => _ManageMasterState();
}

class _ManageMasterState extends State<ManageMaster> {
  int bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    var tabs = [
      Users(user_type: widget.user_type, id: widget.id),
      Events(),
      News(),
      Sponsors(),
      Admins()
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
                        Icons.person,
                        color:
                            bottomNavIndex == 0 ? Colors.white : Colors.black54,
                      ),
                      Text(
                        'Usuarios',
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
                        Icons.star,
                        color:
                            bottomNavIndex == 1 ? Colors.white : Colors.black54,
                      ),
                      Text(
                        'Eventos',
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
                        Icons.book,
                        color:
                            bottomNavIndex == 2 ? Colors.white : Colors.black54,
                      ),
                      Text(
                        'Noticias',
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
                        Icons.group_outlined,
                        color:
                            bottomNavIndex == 3 ? Colors.white : Colors.black54,
                      ),
                      Text(
                        'Patrocinadores',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: bottomNavIndex == 3
                                    ? Colors.white
                                    : Colors.black54,
                                fontSize: 10,
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
                    bottomNavIndex = 4;
                  });
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_ind_outlined,
                        color:
                            bottomNavIndex == 4 ? Colors.white : Colors.black54,
                      ),
                      Text(
                        'Fans',
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
                tabs[bottomNavIndex],
              ],
            ),
          )),
    ));
  }
}
