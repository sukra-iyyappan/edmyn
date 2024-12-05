import 'dart:io';
import 'dart:typed_data';
import 'package:edmyn/dashboard/models/edmyn_resource_model.dart';
import 'package:edmyn/firestore/services/firestore_service.dart';
import 'package:edmyn/shared/navigation/custom_app_bar.dart';
import 'package:edmyn/shared/navigation/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewer extends StatefulWidget {
  final Uint8List pdfData;
  final String resourceId;
  final String appBarTitle;

  PdfViewer(
      {required this.pdfData,
      required this.resourceId,
      required this.appBarTitle});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static const screenId = 'PROFILE-RESOURCE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: widget.appBarTitle,
        scaffoldKey: scaffoldKey,
      ),
      drawer: CustomDrawer(
        screenId: screenId,
      ),
      body: PDFView(
        // You need to save the PDF data to a file and provide the file path
        filePath: _savePdfToFile(widget.pdfData),
      ),
    );
  }

  // Save the PDF data to a temporary file
  String _savePdfToFile(Uint8List pdfData) {
    final directory = Directory.systemTemp;
    final filePath = '${directory.path}/temp.pdf';
    final file = File(filePath);
    file.writeAsBytesSync(pdfData);
    return filePath;
  }
}
