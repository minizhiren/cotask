import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? text;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.text,
    this.controller,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  Color _textColor = Color.fromARGB(86, 50, 50, 50); // Initial gray color

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_checkTextChange);
  }

  void _checkTextChange() {
    setState(() {
      _textColor = _controller.text == widget.text
          ? Color.fromARGB(86, 50, 50, 50) // Gray color when text matches hint
          : Colors.black; // Black color when text is different
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_checkTextChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
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
        controller: _controller,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.transparent,
        cursorWidth: 0.0,
        style: TextStyle(
          color: _textColor, // Use dynamic color based on text change
          fontSize: 16,
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(4.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x3FFA7D8A),
              width: 3.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(150, 250, 125, 137),
              width: 3.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          hintStyle: TextStyle(
            color: Color.fromARGB(86, 50, 50, 50),
            fontSize: 16,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
          ),
          hintText: widget.text,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
