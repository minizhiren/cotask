// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
//提供的输入框
//在textstarfield中密码显示为加密星号
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? text;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.text,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x33FCBABA),
            spreadRadius: 3,
            blurRadius: 3,
          ),
        ],
      ),
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.center,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: Colors.transparent, // Set cursor color to transparent
          cursorWidth: 0.0,
          style: const TextStyle(
            color: Color.fromARGB(86, 50, 50, 50),
            fontSize: 16,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(4.0),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0x3FFA7D8A), // Change border color
                width: 3.0, // Change border width
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(8.0)), // Change border radius
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color:
                    Color.fromARGB(150, 250, 125, 137), // Change border color
                width: 3.0, // Change border width
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(8.0)), // Change border radius
            ),
            hintStyle: const TextStyle(
              color: Color.fromARGB(86, 50, 50, 50),
              fontSize: 16,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
            ),
            hintText: text,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }
}

class CustomText2Field extends StatefulWidget {
  final String? text;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomText2Field({
    Key? key,
    this.text,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomText2FieldState createState() => _CustomText2FieldState();
}

class _CustomText2FieldState extends State<CustomText2Field> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x33FCBABA),
            spreadRadius: 3,
            blurRadius: 3,
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        obscureText: _obscureText, // Enable obscure text
        obscuringCharacter: '*', // Set the obscuring character
        style: const TextStyle(
          color: Color.fromARGB(86, 50, 50, 50),
          fontSize: 16,
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(4.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x3FFA7D8A), // Change border color
              width: 3.0, // Change border width
            ),
            borderRadius:
                BorderRadius.all(Radius.circular(8.0)), // Change border radius
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(150, 250, 125, 137), // Change border color
              width: 3.0, // Change border width
            ),
            borderRadius:
                BorderRadius.all(Radius.circular(8.0)), // Change border radius
          ),
          hintStyle: const TextStyle(
            color: Color.fromARGB(86, 50, 50, 50),
            fontSize: 16,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
          ),
          hintText: '',
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.redAccent, // Set the color of the icon
            ),
            onPressed: _toggleVisibility,
          ),
        ),
      ),
    );
  }
}
