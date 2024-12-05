import 'package:edmyn/dashboard/models/edmyn_resource_model.dart';
import 'package:edmyn/firestore/services/firestore_service.dart';
import 'package:edmyn/shared/navigation/custom_app_bar.dart';
import 'package:edmyn/shared/navigation/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    super.key,
    required this.url,
     this.resourceId,
    required this.appBarTitle,
  });

  final String url;
  final String? resourceId;
  final String appBarTitle;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  String authorName = '';
  bool _isLoading = true;
  static const screenId = 'DASHBOARD';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer here

    _videoPlayerController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
          _videoPlayerController.play(); // Start playing the video
        });
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      allowMuting: true,
      looping: false,
      autoPlay: true,
      showControlsOnInitialize: true,
      customControls: CustomControls(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer here
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is in the background, pause the video
      _videoPlayerController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          title: widget.appBarTitle,
          scaffoldKey: scaffoldKey,
        ),
        drawer: CustomDrawer(screenId: screenId),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: _chewieController,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }
}

class CustomControls extends StatefulWidget {
  const CustomControls({Key? key}) : super(key: key);

  @override
  _CustomControlsState createState() => _CustomControlsState();
}

class _CustomControlsState extends State<CustomControls> {
  late VideoPlayerController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = ChewieController.of(context)!.videoPlayerController;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MaterialControls(
          showPlayButton: true,
        ),
      ],
    );
  }
}
