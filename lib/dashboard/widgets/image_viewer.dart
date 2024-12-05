import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:edmyn/shared/navigation/custom_app_bar.dart';
import 'package:edmyn/shared/navigation/custom_drawer.dart';

class ImageViewer extends StatefulWidget {
  final Uint8List imageData;
  final String resourceId;
  final String appBarTitle;

  ImageViewer({
    required this.imageData,
    required this.resourceId,
    required this.appBarTitle,
  });

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late PhotoViewController _controller;
  static const screenId = 'PROFILE-RESOURCE';

  @override
  void initState() {
    super.initState();
    _controller = PhotoViewController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _zoomIn() {
    _controller.scale = _controller.scale! * 1.2;
  }

  void _zoomOut() {
    _controller.scale = _controller.scale! / 1.2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(title: widget.appBarTitle, scaffoldKey: scaffoldKey),
      drawer: CustomDrawer(
        screenId: screenId,
      ),
      body: Center(
        child: PhotoView(
          imageProvider: MemoryImage(widget.imageData),
          controller: _controller,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _zoomIn,
            child: Icon(Icons.zoom_in),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _zoomOut,
            child: Icon(Icons.zoom_out),
          ),
        ],
      ),
    );
  }
}
