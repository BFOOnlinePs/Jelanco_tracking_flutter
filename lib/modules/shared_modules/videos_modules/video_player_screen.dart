import 'dart:async'; // Add this for Timer
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _showPlayPauseIcon = false;
  Timer? _hideIconTimer;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((_) {
            setState(() {
              _isLoading = false;
              _videoPlayerController.setLooping(true);
              _videoPlayerController
                  .play(); // Automatically start playing the video
              _isPlaying =
                  true; // Update the state to reflect that the video is playing
            });
            _videoPlayerController.addListener(() {
              setState(() {
                _isPlaying = _videoPlayerController.value.isPlaying;
              });
            });
          });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _hideIconTimer?.cancel(); // Cancel timer when disposing
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
      _isPlaying = _videoPlayerController.value.isPlaying;
      _showPlayPauseIcon = true; // Show the icon when tapped

      // Hide icon after 1 second if the video is playing
      if (_isPlaying) {
        _hideIconTimer?.cancel(); // Cancel any previous timers
        _hideIconTimer = Timer(const Duration(seconds: 1), () {
          setState(() {
            _showPlayPauseIcon = false; // Hide icon after delay
          });
        });
      }
    });
  }

  void _showIconTemporarily() {
    setState(() {
      // _showPlayPauseIcon = true; // Show icon when tapped anywhere on the screen
      _showPlayPauseIcon =
          !_showPlayPauseIcon; // Show icon when tapped anywhere on the screen

      // Hide icon after 1 second if the video is playing
      if (_isPlaying) {
        _hideIconTimer?.cancel(); // Cancel any previous timers
        _hideIconTimer = Timer(const Duration(seconds: 1), () {
          setState(() {
            _showPlayPauseIcon = false; // Hide icon after delay
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: MyLoader())
          : Center(
              child: GestureDetector(
                onTap: _showIconTemporarily, // Show icon when video is tapped
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    ),
                    AnimatedOpacity(
                      opacity: _showPlayPauseIcon ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300), // Smooth animation
                      child: GestureDetector(
                        onTap: _togglePlayPause,
                        // Toggle play/pause when icon is tapped
                        child: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.white.withOpacity(0.7),
                          size: 80.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
