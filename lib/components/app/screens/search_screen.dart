import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/components/movie/fetch_movies.dart';
import 'package:movie_app/components/movie/video_play_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _queryController = TextEditingController();
  late Stream<QuerySnapshot> _moviesStream;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _moviesStream = MovieService.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF28303D),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 48, 66, 97),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: _queryController.text.isEmpty
                              ? Icon(
                                  Icons.search,
                                  color: Color(0xFFE7E7E7),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _queryController.clear();
                                    });
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    color: Color(0xFFE7E7E7),
                                    size: 18,
                                  ),
                                ),
                          hintText: "Search ...",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: _queryController,
                        onChanged: _onSearchTextChanged,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 48, 66, 97),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.equalizer_sharp, color: Colors.white),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Stack(
                children: [
                  _buildOriginalWidget(),
                  if (_isSearching) _buildSearchOverlay(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalWidget() {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        } else {
          return StreamBuilder<QuerySnapshot>(
            stream: _moviesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Return an empty container while waiting for data
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final movies = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movieData =
                        movies[index].data() as Map<String, dynamic>;
                    final posterUrl = movieData['posterUrl'] ?? '';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl: posterUrl ?? '',
                            width: MediaQuery.of(context).size.width < 614
                                ? 130
                                : 200,
                            height: 130.0,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child:
                                  CircularProgressIndicator(), // Placeholder indicator
                            ),
                          ),
                        ),
                        title: Text(
                          movieData['name'].length > 20
                              ? movieData['name'].substring(0, 20) + '...'
                              : movieData['name'] ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlayVideoScreen(movie: movieData),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _buildSearchOverlay() {
    return StreamBuilder<QuerySnapshot>(
      stream: _moviesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final movies = snapshot.data!.docs;
          final filteredMovies = movies.where((movie) {
            final movieData = movie.data() as Map<String, dynamic>;
            final movieName = movieData['name'] as String;
            final searchText = _queryController.text.toLowerCase();
            return movieName.toLowerCase().contains(searchText);
          }).toList();
          return Container(
            child: ListView.builder(
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) {
                final movieData =
                    filteredMovies[index].data() as Map<String, dynamic>;
                final posterUrl = movieData['posterUrl'] ?? '';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: posterUrl ?? '',
                        width:
                            MediaQuery.of(context).size.width < 614 ? 130 : 200,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      movieData['name'].length > 20
                          ? movieData['name'].substring(0, 20) + '...'
                          : movieData['name'] ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlayVideoScreen(movie: movieData),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 9,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0), // Adjust the vertical padding
          child: Shimmer.fromColors(
            baseColor: Color.fromARGB(206, 224, 224, 224),
            highlightColor: Color.fromARGB(144, 245, 245, 245),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Color.fromARGB(206, 224, 224, 224),
                  width: 130,
                  height: 150,
                ),
              ),
              title: Container(
                color: Colors.grey[300],
                height: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSearchTextChanged(String newText) {
    if (newText.isNotEmpty) {
      setState(() {
        _isSearching = true;
        // Update _moviesStream to filter the movies based on the search query
        _moviesStream = FirebaseFirestore.instance
            .collection('series')
            .where('name', isGreaterThanOrEqualTo: newText)
            .where('name', isLessThan: newText + 'z')
            .snapshots();
      });
    } else {
      setState(() {
        _isSearching = false;
        _moviesStream = MovieService.getMovies();
      });
    }
  }
}
