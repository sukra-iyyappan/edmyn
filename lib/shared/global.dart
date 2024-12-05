import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String userName = '';
String userId = '';
String userType = '';
String userEmail = '';
String orgId = '';
String orgName = '';
String userRole = '';
String accessToken = '';
String lastLogin = '29 Aug 2023 11:45';
String loginId = '';
String otpSecret = '';

purgeSessionData() {
  userName = '';
  userId = '';
  userType = '';
  userEmail = '';
  orgId = '';
  orgName = '';
  userRole = '';
  accessToken = '';
  lastLogin = '';
  loginId = '';
  otpSecret = '';
}
