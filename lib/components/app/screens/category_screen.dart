import 'package:flutter/material.dart';
import 'package:movie_app/components/utils/categories.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/images/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Color.fromRGBO(37, 29, 29, 0.867)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, "/");
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(Icons.arrow_back_ios),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/");
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                color: Color.fromARGB(193, 255, 255, 255),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        "Choose your Interest",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "Movie categories help the app understand your preferences and interests. By selecting categories that align with your taste, the app can provide personalized recommendations that are more likely to match your preferences.",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 25,
                  children: [
                    Row(
                      children: [
                        Category(
                          category: "Action",
                          bg: Colors.purple,
                          textColor: Colors.white,
                        ),
                        SizedBox(width: 16),
                        Category(
                          category: "Horror",
                          bg: Colors.white,
                          textColor: Colors.black,
                        ),
                        SizedBox(width: 16),
                        Category(
                          category: "Comedy",
                          bg: Colors.purple,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Category(
                          category: "Fantasy",
                          bg: Colors.white,
                          textColor: Colors.black,
                        ),
                        SizedBox(width: 16),
                        Category(
                          category: "Documentary",
                          bg: Colors.white,
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Category(
                          category: "Adventure",
                          bg: Colors.purple,
                          textColor: Colors.white,
                        ),
                        SizedBox(width: 16), // Add space between categories
                        Category(
                          category: "Drama",
                          bg: Colors.white,
                          textColor: Colors.black,
                        ),
                        SizedBox(width: 16), // Add space between categories
                        Category(
                          category: "Musical",
                          bg: Colors.purple,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Category(
                          category: "Romance",
                          bg: Colors.white,
                          textColor: Colors.black,
                        ),
                        SizedBox(width: 16), // Add space between categories
                        Category(
                          category: "Sports",
                          bg: Colors.purple,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/");
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width - 40,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
