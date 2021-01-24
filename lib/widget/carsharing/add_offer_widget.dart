import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

class AddOffer extends StatefulWidget {
  AddOffer({Key key, this.title}) : super(key: key);
  final String title;
  static String tag = 'AddOffer-page';

  @override
  _AddOfferState createState() => new _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  final db = Firestore.instance;

  TextEditingController Snumbercontroller = TextEditingController();
  TextEditingController Placecontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();

  final _formOffer = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.darkGrey,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: _formOffer,
          child: Column(
            children: [
              SizedBox(height: 50),
              TextFormField(
                validator: _validator,
                controller: Snumbercontroller,
                keyboardType: TextInputType.number,
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
                  hintText: "Numero de asientos disponibles",
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                validator: _validator,
                controller: Placecontroller,
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
                  hintText: "Punto de encuentro",
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                validator: _validator,
                controller: datecontroller,
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
                  hintText: "Selecciona una fecha",
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                validator: _validator,
                controller: timecontroller,
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
                  hintText: "Selecciona una hora",
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  if (_formOffer.currentState.validate()) {
                    _formOffer.currentState.save();
                    AddOffery(
                        context,
                        Snumbercontroller.text.trim(),
                        Placecontroller.text.trim(),
                        datecontroller.text.trim(),
                        _time,
                        widget.title);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                      color: AppColors.amberCanes,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Center(
                    child: Text(
                      msg,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  String _hour, _minute, _time;
  String dateTime;
  DateTime selectedDate = DateTime.now();
  String msg = "Ofrecer asientos";
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

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

        datecontroller.text = DateFormat("dd-MM-yyyy").format(selectedDate);
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
        timecontroller.text = _time;
        print(selectedTime);
        timecontroller.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  String _validator(String value) {
    if (value.length <= 0)
      return 'Este campo es requerido';
    else
      return null;
  }

  Future<void> AddOffery(BuildContext context, String Snumber, String place,
      String date, String time, String user) async {
    try {
      var hey = await db.collection('CarSharing').add({
        'Place': place,
        'S_Available': Snumber,
        'S_Booked': 0,
        'Date': date,
        'Time': time,
        'user': user
      });

      String id = hey.documentID;
      await db.collection('CarSharing').document(id).updateData({
        'Offer_ID': id,
      });

      Snumbercontroller.clear();
      Placecontroller.clear();
      datecontroller.clear();
      timecontroller.clear();
      setState(() {
        msg = "Oferta publicada";
      });
    } catch (e) {
      print(e);
      print("Error");
    }
  }
}
