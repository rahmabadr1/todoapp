import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



  Widget defaultTextForm({
    double width = double.infinity,
    Color background = Colors.white70,
    required TextEditingController fieldcontroler,
    required Icon prefixicon,
    required TextInputType textInput,
    required String Text,
    Function()? onTTapp,
    Function? vaild,
    required Function( dynamic value) validator,
    //    FormFieldValidator<dynamic>? vaild,
    // required Function fun,
  }) =>
      Container(margin: EdgeInsetsDirectional.symmetric(horizontal: 25),
          color: background,
          child: TextFormField(decoration: InputDecoration(labelText: Text,
            labelStyle: TextStyle(
              color: Color.fromARGB(70, 100, 150, 150).withOpacity(0.9),
              fontWeight: FontWeight.normal,
              fontSize: 20,),
            border: OutlineInputBorder(),
            prefixIcon: prefixicon,
          ),
            keyboardType: textInput,
            controller: fieldcontroler,
            onTap: onTTapp,
            validator: validator,
            onFieldSubmitted: (value) {
              print(value);
            },


          )
      );




















