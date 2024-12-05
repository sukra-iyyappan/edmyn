import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

// you can put this function as your required
Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('userrole')
      .where('phoneNumber', isEqualTo: phoneNumber)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

class OtpService {
  static const String otpServiceUrlPrefix =
      'https://4ojouw6l3zqehqa2xxi54bs5rm0mzlvk.lambda-url.ap-south-1.on.aws/';

  // Phone OTP methods (already existing)
  Future<String?> requestForOTP(String phoneNumber) async {
    String? otpOrderId;
    var uri = Uri.parse(Uri.encodeFull(otpServiceUrlPrefix));
    var res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'commandName': 'send_otp',
        'data': {'phoneNumber': '+91$phoneNumber'},
      }),
    );

    if (res.statusCode == 200) {
      var resBody = jsonDecode(res.body);
      print("");
      print('');
      print('request otp : $resBody ');
      otpOrderId = resBody["response"]["order_id"];
      print("OTP Order ID: $otpOrderId");
    }
    print(otpOrderId);
    return otpOrderId;
  }

  Future<Map<String, dynamic>?> verifyOTP(
      String phoneNumber, String orderId, String otp) async {
    var uri = Uri.parse(Uri.encodeFull(otpServiceUrlPrefix));
    var res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'commandName': 'verify_otp',
        'data': {
          'phoneNumber': '+91$phoneNumber',
          'orderId': orderId,
          'otp': otp,
        },
      }),
    );

    if (res.statusCode == 200) {
      var resBody = jsonDecode(res.body) as Map<String, dynamic>;
      print(resBody);
      return resBody;
    }
    return null;
  }

  Future<String?> resendOTP(String orderId) async {
    String? otpOrderId;
    var uri = Uri.parse(Uri.encodeFull(otpServiceUrlPrefix));
    var res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'commandName': 'resend_otp',
        'data': {'orderId': orderId},
      }),
    );

    if (res.statusCode == 200) {
      var resBody = jsonDecode(res.body);
      print('request otp : $resBody ');
      otpOrderId = resBody["response"]["order_id"];
      print("OTP Order ID: $otpOrderId");
    }

    return otpOrderId;
  }

  // Email OTP methods
  Future<String?> requestForEmailOTP(String email) async {
    String? otpOrderId;
    var uri = Uri.parse(Uri.encodeFull(otpServiceUrlPrefix));
    var res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'commandName': 'send_email_otp',
        'data': {'email': email},
      }),
    );

    if (res.statusCode == 200) {
      var resBody = jsonDecode(res.body);
      print('request email otp : $resBody ');
      otpOrderId = resBody["response"]["order_id"];
      print("Email OTP Order ID: $otpOrderId");
    }
    print(otpOrderId);
    return otpOrderId;
  }

  Future<Map<String, dynamic>?> verifyEmailOTP(
      String email, String orderId, String otp) async {
    var uri = Uri.parse(Uri.encodeFull(otpServiceUrlPrefix));
    var res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'commandName': 'verify_email_otp',
        'data': {
          'email': email,
          'orderId': orderId,
          'otp': otp,
        },
      }),
    );

    if (res.statusCode == 200) {
      var resBody = jsonDecode(res.body) as Map<String, dynamic>;
      print(resBody);
      return resBody;
    }
    return null;
  }

  Future<String?> resendEmailOTP(String email, String orderId) async {
    String? otpOrderId;
    var uri = Uri.parse(Uri.encodeFull(otpServiceUrlPrefix));
    var res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'commandName': 'resend_email_otp',
        'data': {
          'email': email,
          'orderId': orderId,
        },
      }),
    );

    if (res.statusCode == 200) {
      var resBody = jsonDecode(res.body);
      print('resend email otp : $resBody ');
      otpOrderId = resBody["response"]["order_id"];
      print("Resent Email OTP Order ID: $otpOrderId");
    }

    return otpOrderId;
  }
}
