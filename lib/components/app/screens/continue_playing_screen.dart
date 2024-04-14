import 'package:flutter/material.dart';

class ContinueWatchingScreen extends StatelessWidget {
  const ContinueWatchingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF28303D),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Continue Watching",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w500)),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                )
              ],
            ),
            SizedBox(
              height: 2,
            ),
            Container(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image(image: AssetImage("lib/images/img2.jpg")),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image(image: AssetImage("lib/images/img2.jpg")),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      image: AssetImage("lib/images/img2.jpg"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
