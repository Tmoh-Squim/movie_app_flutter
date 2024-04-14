import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String category;
  final bg;
  final textColor;
  const Category(
      {super.key,
      required this.category,
      required this.bg,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        category,
        style: TextStyle(color: textColor, fontSize: 17),
      ),
    );
  }
}
