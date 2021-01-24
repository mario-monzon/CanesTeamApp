import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'file:///C:/Users/Mario/FlutterProjects/canes_flutter_app/lib/design/app_colors.dart';

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType type;

  MyTextField(this.hint, this.controller, this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        validator: _validator,
        keyboardType: type,
        controller: controller,
        cursorColor: AppColors.amberCanes,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(color: AppColors.amberCanes)),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(14.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: AppColors.amberCanes)),
//          prefixIcon: Icon(
//            Icons.mail_outline,
//            color: Colors.white,
//          ),
          hintStyle:
              GoogleFonts.poppins(textStyle: TextStyle(color: Colors.blueGrey)),
          hintText: hint,
        ),
      ),
    );
  }

  String _validator(String value) {
    if (value.isEmpty)
      return 'Este campo es requerido';
    else
      return null;
  }
}
