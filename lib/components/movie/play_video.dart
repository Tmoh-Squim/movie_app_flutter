import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/components/app/screens/search_screen.dart';
import 'package:movie_app/components/movie/video_play_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: MovieService.getMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading(context);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final movies = snapshot.data?.docs;
          return MediaQuery.of(context).size.width > 935
              ? _buildGridView(context, movies, crossAxisCount: 6)
              : _buildGridView(context, movies, crossAxisCount: 3);
        }
      },
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    int itemCount = MediaQuery.of(context).size.width < 614 ? 18 : 30;

    return GridView.builder(
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width < 614 ? 3 : 6,
        crossAxisSpacing: 3.0,
        mainAxisSpacing: 3.0,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width < 614 ? 102.0 : 200.0,
            height: 135.0,
          ),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, List<DocumentSnapshot>? movies,
      {required int crossAxisCount}) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 613 ? 20 : 0),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 2.0, // Add spacing between movies
            children: [
              for (var movie in movies ?? [])
                Padding(
                  padding: EdgeInsets.all(0),
                  child:
                      _buildMovieTile(context, movie.data(), movie['isSeries']),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieTile(
      BuildContext context, Map<String, dynamic> data, bool isSeries) {
    return GestureDetector(
      onTap: () {
        _navigateToMovieDetail(context, data, isSeries);
      },
      child: Container(
        width: MediaQuery.of(context).size.width < 684
            ? 103
            : MediaQuery.of(context).size.width < 714
                ? 210
                : MediaQuery.of(context).size.width < 799
                    ? 220
                    : 250,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: data['posterUrl'] ?? '',
              width: MediaQuery.of(context).size.width < 684
                  ? 103
                  : MediaQuery.of(context).size.width < 714
                      ? 210
                      : MediaQuery.of(context).size.width < 799
                          ? 220
                          : 250,
              height: MediaQuery.of(context).size.width < 614 ? 130 : 170,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[500]!,
                highlightColor: Colors.grey[300]!,
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width < 684
                      ? 103
                      : MediaQuery.of(context).size.width < 714
                          ? 210
                          : MediaQuery.of(context).size.width < 799
                              ? 220
                              : 250,
                  height: MediaQuery.of(context).size.width < 614 ? 130 : 170,
                ),
              ),
            ),
            SizedBox(height: 2.0),
            Container(
              child: Text(
                data['name'].length > 12
                    ? data['name'].substring(0, 12) + '...'
                    : data['name'] ?? '',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMovieDetail(
      BuildContext context, Map<String, dynamic> data, bool isSeries) {
    if (isSeries) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SeriesMovieDetail(movie: data),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayVideoScreen(movie: data),
        ),
      );
    }
  }
}

class SeriesMovieDetail extends StatelessWidget {
  final Map<String, dynamic> movie;

  SeriesMovieDetail({required this.movie});

  @override
  Widget build(BuildContext context) {
    // Extract series-specific data and display
    return Scaffold(
      appBar: AppBar(title: Text(movie['name'] ?? '')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(movie['description'] ?? ''),
            Image.network(movie['posterUrl'] ?? ''),
            // You can display episodes here
          ],
        ),
      ),
    );
  }
}
