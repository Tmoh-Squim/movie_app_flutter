import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/components/movie/video_play_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ConditionalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double appBarHeight;

  ConditionalAppBar({required this.title, this.appBarHeight = kToolbarHeight});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: SizedBox.shrink(),
      );
    } else {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        toolbarHeight: appBarHeight,
      );
    }
  }

  @override
  Size get preferredSize => kIsWeb ? Size.fromHeight(0) : Size.fromHeight(8);
}

class PlayVideoScreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  PlayVideoScreen({required this.movie});

  @override
  _PlayVideoScreenState createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  ChewieController? _chewieController;
  late SharedPreferences _prefs;
  late String _videoId;
  late int _lastPosition;
  late bool _isVideoLoading;

  @override
  void initState() {
    super.initState();
    _videoId = widget.movie['id'];
    _isVideoLoading = true;
    _initializePlayer();
  }

  void _initializePlayer() async {
    _prefs = await SharedPreferences.getInstance();

    final int? lastPosition = _prefs.getInt('$_videoId:lastPosition');
    setState(() {
      _lastPosition = lastPosition ?? 0;
    });

    final VideoPlayerController videoPlayerController =
        VideoPlayerController.network(widget.movie['videoUrl']);

    // Set cache extent to load video in chunks
    videoPlayerController.setLooping(true);
    videoPlayerController.setVolume(1.0);
    videoPlayerController.initialize().then((_) {
      videoPlayerController.seekTo(Duration(seconds: _lastPosition));
      videoPlayerController.play();
    });

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
      autoInitialize: true,
      allowFullScreen: true,
      aspectRatio: kIsWeb
          ? MediaQuery.of(context).size.width /
              MediaQuery.of(context).size.height
          : 16 / 9,
      showControls: true,
      placeholder: _isVideoLoading
          ? _buildPlaceholder()
          : null, // Use null when video is initialized
    );

    // Listen for when the video is initialized
    videoPlayerController.addListener(() {
      if (videoPlayerController.value.isInitialized) {
        setState(() {
          _isVideoLoading = false;
        });
      }
    });

    // Save the last position of the video
    videoPlayerController.addListener(_saveLastPosition);
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.black,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _chewieController?.videoPlayerController.removeListener(_saveLastPosition);
    _chewieController?.pause();
    _chewieController?.dispose();
    super.dispose();
  }

  void _saveLastPosition() {
    final currentPosition =
        _chewieController?.videoPlayerController.value.position.inSeconds;
    if (currentPosition != null) {
      _prefs.setInt('$_videoId:lastPosition', currentPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConditionalAppBar(title: 'Video'),
      backgroundColor: Color(0xFF0000004b),
      body: Column(
        children: [
          _buildMainVideo(),
          SizedBox(height: 20),
          /*  Expanded(
            child: _buildOtherVideos(),
          ), */
        ],
      ),
    );
  }

  Widget _buildMainVideo() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          if (_chewieController != null)
            Chewie(
              controller: _chewieController!,
            ),
          if (_isVideoLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildOtherVideos() {
    return SingleChildScrollView(
      child: Container(
        child: FutureBuilder<QuerySnapshot>(
          future:
              FirebaseFirestore.instance.collection('series').limit(6).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading(context);
            } else {
              final movies = snapshot.data?.docs;
              return Column(
                children: movies?.map((movie) {
                      final movieData = movie.data() as Map<String, dynamic>;
                      return _buildMovieTile(context, movieData);
                    }).toList() ??
                    [],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMovieTile(BuildContext context, Map<String, dynamic> movie) {
    return GestureDetector(
      onTap: () {
        _navigateToMovieDetail(context, movie);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie['posterUrl'] ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: IconButton(
                onPressed: () {
                  _navigateToMovieDetail(context, movie);
                },
                icon: Icon(
                  Icons.play_circle_outline,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMovieDetail(
      BuildContext context, Map<String, dynamic> movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayVideoScreen(movie: movie),
      ),
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
}
