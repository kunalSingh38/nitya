import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewVideoPlayer extends StatefulWidget {
  final String url;
  final bool isPlayable;

  ChewVideoPlayer(this.url, this.isPlayable);

  @override
  _ChewVideoPlayerState createState() => _ChewVideoPlayerState();
}

class _ChewVideoPlayerState extends State<ChewVideoPlayer> {
  VideoPlayerController videoPlayerController;

  ChewieController chewieController;

  @override
  void initState() {
    // TODO: implement initState
    videoPlayerController = VideoPlayerController.network(widget.url);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      autoInitialize: true,
      showControls: true,
      placeholder: Container(
        child: Center(
          child: Icon(Icons.ondemand_video),
        ),
      ),
      looping: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Chewie(
        controller: chewieController,
      ),
    );
  }
}
