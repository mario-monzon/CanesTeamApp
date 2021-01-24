import 'package:canes_app/widget/carsharing/add_offer_widget.dart';
import 'package:canes_app/widget/carsharing/all_offers_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';
import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/widget/carsharing/my_offers_widget.dart';

class CarSharing extends StatefulWidget {
  CarSharing({Key key, this.title}) : super(key: key);
  final String title;
  static String tag = 'CarSharing-page';
  @override
  _CarSharingState createState() => new _CarSharingState();
}

class _CarSharingState extends State<CarSharing>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: AppColors.amberCanes,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Center(
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              isScrollable: true,
              labelPadding: EdgeInsets.only(right: 20.0, left: 20.0),
              unselectedLabelColor: AppColors.darkGrey,
              tabs: [
                Tab(text: 'Asientos disponibles'),
                Tab(text: 'Mis Asientos'),
                Tab(text: 'Ofrecer Asientos'),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: AppColors.darkGrey,
          child: TabBarView(controller: _tabController, children: [
            AllOffersPage(title: widget.title),
            MyOffersPage(title: widget.title),
            AddOffer(title: widget.title)
          ]),
        ),
      ],
    ));
  }
}
