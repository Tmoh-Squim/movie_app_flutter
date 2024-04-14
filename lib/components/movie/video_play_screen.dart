import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

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
      showControls: true,
      placeholder: _isVideoLoading ? _buildPlaceholder() : null, // Use null when video is initialized
      aspectRatio: 16 / 9,
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
      appBar: AppBar(title: Text(widget.movie['name'] ?? '')),
      backgroundColor: Color(0xFF0000004b),
      body: Stack(
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
}
