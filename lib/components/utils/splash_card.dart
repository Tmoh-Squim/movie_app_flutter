import 'package:flutter/material.dart';

class SplashCard extends StatelessWidget {
  final String title;
  final String imgUrl;
  const SplashCard({super.key, required this.title, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage(imgUrl), fit: BoxFit.cover)),
          width: MediaQuery.of(context).size.width,
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        )
      ],
    );
  }
}
