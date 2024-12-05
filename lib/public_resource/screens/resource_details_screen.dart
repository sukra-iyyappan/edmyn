// import 'dart:typed_data';
// import 'package:edmyn/shared/navigation/custom_app_bar.dart';
// import 'package:edmyn/shared/navigation/custom_drawer.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../dashboard/models/edmyn_resource_model.dart';
// import '../../dashboard/widgets/image_viewer.dart';
// import '../../dashboard/widgets/pdf_viewer.dart';
// import '../../dashboard/widgets/video_player.dart';
// import '../../firestore/services/firestore_service.dart';
// import '../../shared/file_downloader.dart';
// import '../../shared/utils.dart' as utils;
// import '../models/public_resource_model.dart';
//
// class ResourceDetailsScreen extends StatefulWidget {
//   final FileUpload resource;
//
//   ResourceDetailsScreen({required this.resource});
//
//   @override
//   State<ResourceDetailsScreen> createState() => _ResourceDetailsScreenState();
// }
//
// class _ResourceDetailsScreenState extends State<ResourceDetailsScreen> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   static const screenId = 'PROFILE-RESOURCE';
//   bool _isLoading = false;
//
//   Future<void> _launchURL(String url) async {
//     try {
//       final Uri uri = Uri.tryParse(url) ?? Uri();
//       if (uri.isAbsolute) {
//         final bool launched =
//             await launchUrl(uri, mode: LaunchMode.externalApplication);
//         if (!launched) {
//           customSnackBar('Could not launch $url');
//         }
//       } else {
//         customSnackBar('Invalid URL');
//       }
//     } catch (e) {
//       customSnackBar('Error launching URL: ${e.toString()}');
//     }
//   }
//
//   Future<void> _handleEdmynResource(String edmynResourceId) async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       EdmynResource? edmynResource =
//           await FirestoreService().getEdmynResourceByFilename(edmynResourceId);
//
//       if (edmynResource == null) {
//         customSnackBar('Resource does not exist');
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }
//
//       String extension =
//           edmynResource.resourceUrl.split('.').last.toLowerCase();
//       String url = '';
//       String authorFormatted = edmynResource.resourceName;
//
//       if (['mp4', 'mpeg4', 'mkv'].contains(extension)) {
//         // Handle video resources
//         if (edmynResource.urlType == 'internal') {
//           final gsReference = FirebaseStorage.instance.refFromURL(
//               "gs://edmyn-dev.appspot.com/uploads/${edmynResource.resourceUrl.split('/').last}");
//           url = await gsReference.getDownloadURL();
//         } else {
//           url = edmynResource.resourceUrl;
//         }
//         _openVideoPlayer(url, edmynResourceId, authorFormatted);
//       } else if (['jpg', 'png', 'jpeg', 'gif'].contains(extension)) {
//         // Handle image resources
//         Uint8List? data;
//         if (edmynResource.urlType == 'internal') {
//           final gsReference = FirebaseStorage.instance.refFromURL(
//               "gs://edmyn-dev.appspot.com/uploads/${edmynResource.resourceUrl.split('/').last}");
//           data = await gsReference.getData();
//         } else {
//           data = await getFileDataFromUrl(edmynResource.resourceUrl);
//         }
//         _openImageViewer(data, edmynResourceId, authorFormatted);
//       } else if (extension == 'pdf') {
//         // Handle PDF resources
//         Uint8List? data;
//         if (edmynResource.urlType == 'internal') {
//           final gsReference = FirebaseStorage.instance.refFromURL(
//               "gs://edmyn-dev.appspot.com/uploads/${edmynResource.resourceUrl.split('/').last}");
//           data = await gsReference.getData();
//         } else {
//           data = await getFileDataFromUrl(edmynResource.resourceUrl);
//         }
//         _openPdfViewer(data, edmynResourceId, authorFormatted);
//       } else {
//         customSnackBar('Unknown resource type');
//       }
//     } catch (e) {
//       print('Error handling resource: $e');
//       customSnackBar('Error handling resource: ${e.toString()}');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _openVideoPlayer(String url, String resourceId, String appBarTitle) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => VideoPlayer(
//           url: url,
//           resourceId: resourceId,
//           appBarTitle: appBarTitle,
//         ),
//       ),
//     );
//   }
//
//   void _openImageViewer(
//       Uint8List? data, String resourceId, String appBarTitle) {
//     if (data != null) {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => ImageViewer(
//             imageData: data,
//             resourceId: resourceId,
//             appBarTitle: appBarTitle,
//           ),
//         ),
//       );
//     } else {
//       customSnackBar('Failed to load image');
//     }
//   }
//
//   void _openPdfViewer(Uint8List? data, String resourceId, String appBarTitle) {
//     if (data != null) {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => PdfViewer(
//             pdfData: data,
//             resourceId: resourceId,
//             appBarTitle: appBarTitle,
//           ),
//         ),
//       );
//     } else {
//       customSnackBar('Failed to load PDF');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: CustomAppBar(title: 'Resource Details', scaffoldKey: scaffoldKey),
//       drawer: CustomDrawer(screenId: screenId),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Name: ${widget.resource.nameoftheresource}'),
//             utils.kHTinyGap(),
//             Text('Book Name: ${widget.resource.bookName}'),
//             utils.kHTinyGap(),
//             Text('Chapter: ${widget.resource.chapter}'),
//             utils.kHTinyGap(),
//             Text('Class : ${widget.resource.classLevel}'),
//             utils.kHTinyGap(),
//             Text('Description: ${widget.resource.description}'),
//             utils.kHTinyGap(),
//             Text('Edition: ${widget.resource.edition}'),
//             utils.kHTinyGap(),
//             Text('Subject Name: ${widget.resource.subjectName}'),
//             utils.kHTinyGap(),
//             GestureDetector(
//               onTap: () async {
//                 final url = widget.resource.resourceUrl;
//                 print('Clicked URL: $url');
//
//                 if (url.contains('edmyn.com') ||
//                     url.contains('storage.googleapis.com')) {
//                   final edmynResourceId = _extractEdmynResourceId(url);
//                   print('Edmyn Resource ID: $edmynResourceId');
//
//                   if (edmynResourceId != null) {
//                     print('Handling Edmyn resource with ID: $edmynResourceId');
//                     await _handleEdmynResource(edmynResourceId);
//                   } else {
//                     print('Invalid Edmyn Resource ID');
//                     customSnackBar('Invalid Edmyn Resource ID');
//                   }
//                 } else {
//                   print('Launching external URL: $url');
//                   await _launchURL(url);
//                 }
//               },
//               child: Text(
//                 'Resource URL: ${widget.resource.resourceUrl}',
//                 style: textTheme.bodySmall?.copyWith(
//                   color: Colors.blue,
//                   decoration: TextDecoration.underline,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             utils.kHTinyGap(),
//             Text(
//               widget.resource.uploadTime != null
//                   ? 'Uploaded on: ${DateFormat('dd-MM-yyyy').format(widget.resource.uploadTime!)}'
//                   : 'No upload time',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String? _extractEdmynResourceId(String url) {
//     final Uri uri = Uri.tryParse(url) ?? Uri();
//     if (uri.pathSegments.isNotEmpty) {
//       return uri.pathSegments.last;
//     }
//     return null;
//   }
//
//   void customSnackBar(String message) {
//     ScaffoldMessenger.of(context);
//   }
// }
