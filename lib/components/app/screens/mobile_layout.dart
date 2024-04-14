import 'package:flutter/material.dart';
import 'package:movie_app/components/app/screens/search_screen.dart';
import 'package:movie_app/components/movie/play_video.dart';
import 'package:movie_app/components/movie/upload_single_movie.dart';
import 'package:movie_app/components/utils/home_screen_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: Color.fromARGB(136, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MovieList()));
              },
              icon: Icon(
                Icons.home,
                size: 35,
                color: Colors.purple,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                );
              },
              icon: Icon(Icons.search, size: 35),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieUploadScreen()));
              },
              icon: Icon(Icons.play_arrow_rounded, size: 35),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              icon: Icon(Icons.person_2_rounded, size: 35),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    HomeCard(
                      imgUrl: "lib/images/bg.jpg",
                      title: "Doctor Stranges",
                    ),
                    HomeCard(
                      imgUrl: "lib/images/img2.jpg",
                      title: "Red Notice",
                    ),
                    HomeCard(
                      imgUrl: "lib/images/img1.jpg",
                      title: "Day and Knight",
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 5,
                  effect: WormEffect(
                    dotWidth: 10.0,
                    dotHeight: 10.0,
                    paintStyle: PaintingStyle.stroke,
                    dotColor: Color(0xFF9BA0A6),
                    activeDotColor: Colors.white,
                  ),
                  onDotClicked: (index) => _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
