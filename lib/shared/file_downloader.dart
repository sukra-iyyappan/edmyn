import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<Uint8List> getFileDataFromUrl(String url) async {
  var res = await http.get(Uri.parse(url));
  Uint8List fileBytes = res.bodyBytes;

  return fileBytes;
}