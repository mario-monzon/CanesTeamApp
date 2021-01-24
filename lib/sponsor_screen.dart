import 'package:canes_app/widget/sponsor/sponsor_social_button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'design/app_colors.dart';

class SponsorsPage extends StatefulWidget {
  String id;

  SponsorsPage({this.id});
  @override
  _SponsorsPageState createState() => _SponsorsPageState();
}

class _SponsorsPageState extends State<SponsorsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('sponsors').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: const Text('Cargando eventos...'));
          }
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Column(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: Image.network(
                      snapshot.data.documents[index]['sponsor_logo'],
                      width: 100.0,
                      height: 100.0,
                    ),
                  ),
                  Text(
                    snapshot.data.documents[index]['sponsor_name'],
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: AppColors.amberCanes,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SponsorSocialButton(
                        icon: FaIcon(FontAwesomeIcons.globe),
                        launchUrl: _launchURL(
                            snapshot.data.documents[index]['sponsor_web']),
                      ),
                      SponsorSocialButton(
                        icon: FaIcon(FontAwesomeIcons.facebook),
                        launchUrl: _launchURL(
                            snapshot.data.documents[index]['sponsor_facebook']),
                      ),
                      SponsorSocialButton(
                        icon: FaIcon(FontAwesomeIcons.twitter),
                        launchUrl: _launchURL(
                            snapshot.data.documents[index]['sponsor_twitter']),
                      ),
                      SponsorSocialButton(
                        icon: FaIcon(FontAwesomeIcons.instagram),
                        launchUrl: _launchURL(snapshot.data.documents[index]
                            ['sponsor_instagram']),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                ]),
              );
            },
            itemCount: snapshot.data.documents.length,
          );
        },
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo iniciar $url';
    }
  }
}

BuildItem(DocumentSnapshot doc, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DetailsNew(title: doc)),
      );
    },
    child: Card(
      child: Column(children: <Widget>[
        SizedBox(height: 10.0),
        Row(
          children: [
            SizedBox(width: 30.0),
            Text(
              doc.data['event_title'],
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: AppColors.amberCanes,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600)),
            ),
            SizedBox(width: 10.0),
            Container(
              color: AppColors.amberCanes,
              width: 2.0,
              height: 15.0,
            ),
            SizedBox(width: 10.0),
            Text(
              doc.data['event_date'] + "  " + doc.data['event_time'],
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Detalles :  " + doc.data['event_body'],
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400))),
        ),
        SizedBox(height: 10.0),
      ]),
    ),
  );
}

class DetailsNew extends StatefulWidget {
  DetailsNew({Key key, this.title}) : super(key: key);
  final DocumentSnapshot title;
  static String tag = 'detailsNew-page';

  @override
  _DetailsNewState createState() => new _DetailsNewState();
}

class _DetailsNewState extends State<DetailsNew> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.darkGrey,
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 50.0),
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
                                fontSize: 25,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 10.0),
                      Row(children: [
                        SizedBox(width: 10.0),
                        Text(widget.title.data['news_date'],
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: AppColors.lightGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)))
                      ]),
                      SizedBox(height: 10.0),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.all(10.0),
                          child: Text(
                            widget.title.data['news_body'],
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w200)),
                          ))
                    ]))));
  }
}
