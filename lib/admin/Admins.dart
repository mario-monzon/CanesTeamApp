import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

class Admins extends StatefulWidget {
  static String tag = 'Admins-page';
  @override
  _AdminsState createState() => new _AdminsState();
}

class _AdminsState extends State<Admins> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
                color: AppColors.amberCanes,
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Center(
              child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  isScrollable: true,
                  labelPadding: EdgeInsets.only(right: 20.0, left: 20.0),
                  unselectedLabelColor: AppColors.darkGrey,
                  tabs: [
                    Tab(
                      text: 'Todos los Fans',
                    ),
                  ]),
            )),
        Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: AppColors.darkGrey,
          child: TabBarView(controller: _tabController, children: [
            AdminsPage(
              title: "Administrador",
            ),
          ]),
        ),
      ],
    ));
  }
}

class AdminsPage extends StatefulWidget {
  AdminsPage({Key key, this.title}) : super(key: key);
  final String title;
  static String tag = 'AdminsPage-page';

  @override
  _AdminsPageState createState() => new _AdminsPageState();
}

class _AdminsPageState extends State<AdminsPage> {
  final db = Firestore.instance;

  int hey = 0;
  Card buildItem(DocumentSnapshot doc) {
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Text(
                'Nombre : ${doc.data['first_name']}',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 3.0),
              Text(
                'Email: ${doc.data['email']}',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, //Center Row contents horizontally,
                crossAxisAlignment:
                    CrossAxisAlignment.center, //Center Row contents vertically,
                children: [
                  FlatButton.icon(
                    onPressed: () => DeleteUser(doc.data['uid']),
                    icon: Icon(Icons.delete_forever, color: Colors.white),
                    label: Text(
                      "Borrar usuario",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: AppColors.amberCanes,
                  ),
                ],
              ),
              SizedBox(height: 5.0),
            ]),
      ),
    );
  }

  void DeleteUser(String id) async {
    Widget okButton = FlatButton(
      child: Text("Si ", style: TextStyle(color: AppColors.darkGrey)),
      onPressed: () async {
        await db.collection("Fans").document(id).delete().catchError((e) {
          print(e);
        });
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("  Borrar"),
      content: Text('¿ Eliminar este usuario ?'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: db.collection("Fans").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: snapshot.data.documents
                        .map((doc) => buildItem(doc))
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
