import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:edmyn/dashboard/models/edmyn_resource_model.dart';
import 'package:edmyn/dashboard/widgets/image_viewer.dart';
import 'package:edmyn/dashboard/widgets/pdf_viewer.dart';
import 'package:edmyn/dashboard/widgets/video_player.dart';
import 'package:edmyn/firestore/services/firestore_service.dart';
import 'package:edmyn/shared/file_downloader.dart';
import 'package:edmyn/shared/navigation/custom_app_bar.dart';
import 'package:edmyn/shared/navigation/custom_drawer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:edmyn/shared/styling.dart' as styling;
import 'package:vibration/vibration.dart';

import '../../shared/internet_checker/no_internet_screen.dart';
import '../../shared/internet_checker/connectivity_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static const screenId = "DASHBOARD";
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;
  String? qrcode;


  Future<void> _qrScanner() async {
    // // Check for internet connection
    // final provider = Provider.of<ConnectivityProvider>(context, listen: false);
    // if (!provider.isConnected) {
    //   customSnackBar('Please turn on your internet connection.');
    //   return;
    // }

    var cameraStatus = await Permission.camera.status;

    if (cameraStatus.isGranted) {
      setState(() {
        _isLoading = true;
      });

      try {
        var result = await BarcodeScanner.scan();
        String? qrData = result.rawContent;

        if (qrData != null && qrData.isNotEmpty) {
          // Vibrate on successful scan
          bool? hasVibrator = await Vibration.hasVibrator();
          if (hasVibrator == true) {
            Vibration.vibrate(duration: 100); // vibrate for 100ms
          }

          handleQRData(qrData);
        } else {
          // No data scanned, show a message to the user
          customSnackBar('The scanner was closed.');
        }
      } on PlatformException catch (e) {
        if (e.code == BarcodeScanner.cameraAccessDenied) {
          customSnackBar('Camera permission was denied');
        } else {
          customSnackBar('Unknown error: $e');
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      var permission = await Permission.camera.request();
      if (permission.isGranted) {
        setState(() {
          _isLoading = true;
        });

        try {
          var result = await BarcodeScanner.scan();
          String? qrData = result.rawContent;

          if (qrData != null && qrData.isNotEmpty) {
            bool? hasVibrator = await Vibration.hasVibrator();
            if (hasVibrator == true) {
              Vibration.vibrate(pattern: [0, 200, 100, 200, 300, 200]);
            }
            handleQRData(qrData);
          } else {
            // No data scanned, show a message to the user
            //customSnackBar('No QR code scanned.');
          }
        } on PlatformException catch (e) {
          if (e.code == BarcodeScanner.cameraAccessDenied) {
            customSnackBar('Camera permission was denied');
          } else {
            customSnackBar('Unknown error: $e');
          }
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _qrScanner();
    });
  }

  Future<void> handleQRData(String? data) async {
    if (data != null) {
      try {
        print('QR Code Data: $data');

        if (data.startsWith('{') && data.endsWith('}')) {
          var jsonData = jsonDecode(data);

          if (jsonData.containsKey('edmynResourceId')) {
            await _handleEdmynResource(jsonData);
          } else {
            await _handleOtherData(data); // Handle as 'other' data
          }
        } else {
          await _handleOtherData(data); // Handle external links
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        print('Error decoding QR Code data: $error');
        customSnackBar('Unrecognized QR Code');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      customSnackBar('Invalid QR Code');
    }
  }


  Future<void> _handleEdmynResource(Map<String, dynamic> jsonData) async {
    String edmynResourceId = jsonData['edmynResourceId'];

    EdmynResource? edmynResource =
        await FirestoreService().getEdmynResource(edmynResourceId);

    if (edmynResource != null) {
      String extension = edmynResource.resourceUrl.split('.').last.toString();
      String authorFormatted = edmynResource.resourceName;

      if (context.mounted) {
        if (extension == 'mp4' ||
            extension == 'mpeg4' ||
            extension == 'MP4' ||
            extension == 'MPEG4' ||
            extension == 'MKV' ||
            extension == 'mkv') {
          String url = '';

          if (edmynResource.urlType == 'internal') {
            final gsReference = FirebaseStorage.instance.refFromURL(
                "gs://edmyn-dev.appspot.com/uploads/${edmynResource.resourceUrl.split('/').last}");
            url = await gsReference.getDownloadURL();
          } else {
            url = edmynResource.resourceUrl;
          }

          setState(() {
            _isLoading = false;
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VideoPlayer(
                url: url,
                resourceId: edmynResourceId,
                appBarTitle: authorFormatted,
              ),
            ),
          );
        } else if (extension == 'jpg' ||
            extension == 'png' ||
            extension == 'jpeg' ||
            extension == 'gif'||
            extension == 'JPEG'||
            extension == 'PNG'||
            extension == 'GIF'||
            extension == 'JPG') {
          Uint8List? data;

          if (edmynResource.urlType == 'internal') {
            final gsReference = FirebaseStorage.instance.refFromURL(
                "gs://edmyn-dev.appspot.com/uploads/${edmynResource.resourceUrl.split('/').last}");
            data = await gsReference.getData();
          } else {
            data = await getFileDataFromUrl(edmynResource.resourceUrl);
          }

          setState(() {
            _isLoading = false;
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImageViewer(
                imageData: data!,
                resourceId: edmynResourceId,
                appBarTitle: authorFormatted,
              ),
            ),
          );
        } else if (extension == 'pdf'|| extension =='PDF') {
          Uint8List? data;
          if (edmynResource.urlType == 'internal') {
            final gsReference = FirebaseStorage.instance.refFromURL(
                "gs://edmyn-dev.appspot.com/uploads/${edmynResource.resourceUrl.split('/').last}");
            data = await gsReference.getData();
          } else {
            data = await getFileDataFromUrl(edmynResource.resourceUrl);
          }

          setState(() {
            _isLoading = false;
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PdfViewer(
                pdfData: data!,
                resourceId: edmynResourceId,
                appBarTitle: authorFormatted,
              ),
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          customSnackBar('Unknown resource type');
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      customSnackBar('Resource does not exist');
    }
  }



  Future<void> _uploadImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      customSnackBar('No image selected.');
      return;
    }

    setState(() {
      _isLoading = true; // Indicate loading starts
    });

    try {
      // Read the selected image as bytes
      final imageBytes = await pickedFile.readAsBytes();

      // Save the image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/temp_qr_image.png';
      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(imageBytes);

      // Analyze the image using MobileScannerController
      final mobileScannerController = MobileScannerController(formats: [BarcodeFormat.qrCode]);
      final result = await mobileScannerController.analyzeImage(tempFile.path);

      if (result == null) {
        customSnackBar('Failed to analyze image. Please try again.');
        return;
      }

      if (result.barcodes != null && result.barcodes.isNotEmpty) {
        final qrData = result.barcodes.first.rawValue ?? '';

        if (qrData.isNotEmpty) {
          print('QR Code Data Found: $qrData');
          handleQRData(qrData);
          // customSnackBar('QR Code Data: $qrData');
        } else {
          customSnackBar('No QR code found in the image.');
        }
      } else {
        customSnackBar('No QR code found in the image.');
      }
    } catch (e) {
      customSnackBar('Error analyzing image: $e');
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleOtherData(String data) async {
    final uri = Uri.tryParse(data);
    if (uri != null &&
        uri.isAbsolute &&
        (uri.scheme == 'http' || uri.scheme == 'https')) {
      String extension = uri.path.split('.').last.toLowerCase();
      String authorFormatted =
          'copyright@YourAuthorName';

      if (extension == 'mp4' ||
          extension == 'mpeg4' ||
          extension == 'MP4' ||
          extension == 'MPEG4' ||
          extension == 'MKV' ||
          extension == 'mkv') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoPlayer(
              url: uri.toString(),
              resourceId: 'someResourceId',
              appBarTitle: authorFormatted,
            ),
          ),
        );
      } else {
        // Handle other types of URLs as needed (e.g., images, PDFs, etc.)
        // For example, you might want to open an external browser for links
        bool? shouldOpen = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Non-Edmyn QR Code'),
              content: const Text(
                  'This is a non-Edmyn QR code. Do you want to open it through an external application?'),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Open',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );

        if (shouldOpen == true) {
          await launchURL(uri.toString(), LaunchMode.externalApplication);
        }
      }
    } else {
      customSnackBar('Invalid URL');
    }
  }

  Future<void> launchURL(String url, LaunchMode mode) async {
    if (!await launchUrl(Uri.parse(url), mode: mode)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          drawer: const CustomDrawer(screenId: screenId),
          appBar: CustomAppBar(
            title: 'Dashboard',
            scaffoldKey: scaffoldKey,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(5,5,5,9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'qr_scan',
                  onPressed: _qrScanner,
                  child: const Icon(Icons.qr_code_scanner),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'upload_image',
                  onPressed: _uploadImage,
                  child: const Icon(Icons.image),
                ),
              ],
            ),
          ),
          body: Consumer<ConnectivityProvider>(
            builder: (context, provider, child) {
              // Check connection status
              if (!provider.isConnected) {
                return NoInternetScreen(
                  onRetry: () {},
                );
              }

              return _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Show main content
                    buildCenterImage(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildCenterImage() {
    return const Center(
      child: Opacity(
        opacity: 0.5,
        child: Image(
          fit: BoxFit.contain,
          height: 200,
          image: AssetImage('assets/images/edmyn_blue-logo.png'),
        ),
      ),
    );
  }

  // void customSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(message),
  //     duration: const Duration(seconds: 2),
  //   ));
  // }

  void customSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(8.0),
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

}
