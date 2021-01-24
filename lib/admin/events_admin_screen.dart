import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

class Events extends StatefulWidget {
  static String tag = 'Events-page';
  @override
  _EventsState createState() => new _EventsState();
}

class _EventsState extends State<Events> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                color: AppColors.amberCanes,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nuevo evento',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600)),
                ),
                IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddEvent()),
                      );
                    })
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('Events').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: snapshot.data.documents
                              .map<Widget>((doc) => BuildItem(doc))
                              .toList());
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  final DateTime now = DateTime.now();

  void DeleteEvent(String id) async {
    Widget okButton = FlatButton(
      child: Text(
        "Si ",
        style: TextStyle(color: AppColors.darkGrey),
      ),
      onPressed: () async {
        // FirebaseUser = await FirebaseAuth.instance.ge
        await db.collection("Events").document(id).delete().catchError((e) {
          print(e);
        });
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("  Borrar"),
      content: Text("Quiere borrar este evento ?"),
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

  BuildItem(DocumentSnapshot doc) {
    DateTime tempDate = new DateFormat("dd-MM-yyyy hh:mm")
        .parse(doc.data['E_Date'] + " " + doc.data['E_hour']);

    return GestureDetector(
      onTap: () => print(doc.data['E_ID']),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
                color: now.isBefore(tempDate)
                    ? AppColors.amberCanes.withOpacity(0.3)
                    : AppColors.amberCanes.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 12),
                now.isBefore(tempDate)
                    ? IconButton(
                        onPressed: () => DeleteEvent(doc.data['E_ID']),
                        color: Colors.white,
                        icon: Icon(Icons.delete),
                      )
                    : SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      doc.data['E_Name'],
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: AppColors.amberCanes,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Fecha : ',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          children: [
                            TextSpan(
                              text: doc.data['E_Date'],
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: AppColors.amberCanes,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ]),
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Hora : ',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          children: [
                            TextSpan(
                              text: doc.data['E_hour'],
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: AppColors.amberCanes,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ]),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 8)
        ],
      ),
    );
  }
}

class AddEvent extends StatefulWidget {
  AddEvent({Key key, this.title}) : super(key: key);
  final String title;
  static String tag = 'AddEvent-page';

  @override
  _AddEventState createState() => new _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final db = Firestore.instance;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController positioncontroller = TextEditingController();

  final _formEvent = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.darkGrey,
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Form(
              key: _formEvent,
              child: Column(
                children: [
                  SizedBox(height: 100),
                  TextFormField(
                    validator: _validator,
                    controller: namecontroller,
                    cursorColor: AppColors.amberCanes,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: AppColors.amberCanes)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: AppColors.amberCanes)),
                      hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white)),
                      hintText: "Nombre del evento",
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: _validator,
                    maxLines: 5,
                    controller: desccontroller,
                    cursorColor: AppColors.amberCanes,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: AppColors.amberCanes)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: AppColors.amberCanes)),
                      hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white)),
                      hintText: "Descripción",
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: _validator,
                    controller: _dateController,
                    cursorColor: AppColors.amberCanes,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: AppColors.amberCanes)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: AppColors.amberCanes)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                      ),
                      hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white)),
                      hintText: "Seleccionar una fecha",
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: _validator,
                    controller: _timeController,
                    cursorColor: AppColors.amberCanes,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: AppColors.amberCanes)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: AppColors.amberCanes)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Icon(
                          Icons.timelapse,
                          color: Colors.white,
                        ),
                      ),
                      hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.white)),
                      hintText: "Seleccionar una hora",
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      if (_formEvent.currentState.validate()) {
                        _formEvent.currentState.save();
                        AddEventy(
                            context,
                            namecontroller.text.trim(),
                            desccontroller.text.trim(),
                            _dateController.text.trim(),
                            _time);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                          color: AppColors.amberCanes,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Center(
                        child: Text(
                          "Añadir evento",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    msg,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: AppColors.amberCanes,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            )));
  }

  String _setTime, _setDate;
  String _hour, _minute, _time;
  String dateTime;
  DateTime selectedDate = DateTime.now();
  String msg = " ";
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;

        _dateController.text = DateFormat("dd-MM-yyyy").format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ':' + _minute;
        // _time = _hour + ':' + _minute + '' + '';
        _timeController.text = _time;
        print(selectedTime);
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  String _validator(String value) {
    if (value.length == 0)
      return 'Campo es requerido';
    else
      return null;
  }

  Future<void> AddEventy(BuildContext context, String name, String desc,
      String date, String time) async {
    try {
      var hey = await db.collection('Events').add({
        'E_Name': name,
        'E_Desc': desc,
        'E_Date': date,
        'E_hour': time,
      });

      String id = hey.documentID;
      await db.collection('Events').document(id).updateData({
        'E_ID': id,
      });

      setState(() {
        msg = "Evento Añadido";
      });
    } catch (e) {
      print(e);
      print("Error");
    }
  }
}
