import 'package:flutter/material.dart';

class TrendingMovies extends StatelessWidget {
  const TrendingMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Trending Now",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 17,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
