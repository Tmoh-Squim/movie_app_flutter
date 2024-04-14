import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final String imgUrl;
  const HomeCard({super.key, required this.title, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(imgUrl), fit: BoxFit.cover)),
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
            top: 190,
            left: 5,
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            )),
      ],
    );
  }
}
