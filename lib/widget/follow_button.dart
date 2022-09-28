import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundcolor;
  final Color borderColor;
  final String text;
  final Color textColor;

  const FollowButton({Key? key,
    required this.backgroundcolor,
    required this.borderColor,
    required this.text,
    required this.textColor,
    this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundcolor,
            border: Border.all(color:borderColor ),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(text,style: TextStyle(color:textColor ,fontWeight: FontWeight.bold),),
          width: 250,
          height: 27,
        ),
      ),
    );
  }
}
