// import 'package:edmyn/public_resource/screens/resource_details_screen.dart';
// import 'package:edmyn/public_resource/services/public_resource_service.dart';
// import 'package:edmyn/shared/navigation/custom_app_bar.dart';
// import 'package:edmyn/shared/navigation/custom_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:edmyn/public_resource/models/public_resource_model.dart';
// import 'package:intl/intl.dart';
// import 'package:edmyn/shared/utils.dart' as utils;
//
// class ResourceListScreen extends StatefulWidget {
//   @override
//   _ResourceListScreenState createState() => _ResourceListScreenState();
// }
//
// class _ResourceListScreenState extends State<ResourceListScreen> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   final ResourceService _resourceService = ResourceService();
//
//   static const screenId = 'PROFILE-RESOURCE';
//   Future<List<FileUpload>>? _resourceFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _resourceFuture = _resourceService.fetchResources();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: CustomAppBar(title: 'Public Resource', scaffoldKey: scaffoldKey),
//       drawer: CustomDrawer(screenId: screenId),
//       body: FutureBuilder<List<FileUpload>>(
//         future: _resourceFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//                 child: Text('Error fetching resources: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No resources found.'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 FileUpload resource = snapshot.data![index];
//                 return Card(
//                   margin: EdgeInsets.all(8.0),
//                   child: ListTile(
//                     title: Text(
//                       resource.bookName.isNotEmpty
//                           ? '${resource.nameoftheresource.isNotEmpty ? 'Author: ${resource.nameoftheresource} - ' : ''}${resource.bookName}'
//                           : 'No Title',
//                       style: textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     subtitle: Text(
//                       resource.classLevel.isNotEmpty
//                           ? 'Class: ${resource.classLevel}'
//                           : 'Class: No Class',
//                       style: textTheme.bodySmall?.copyWith(
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     trailing: Text(
//                       resource.uploadTime != null
//                           ? 'Uploaded on: ${DateFormat('dd-MM-yyyy').format(resource.uploadTime!)}' // Format the date
//                           : 'No upload time',
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               ResourceDetailsScreen(resource: resource),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
