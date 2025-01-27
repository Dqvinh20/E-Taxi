import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AppConstants {
  static const String helloNiceToMeetYou = 'Hello, nice to meet you!';
  static const String getMovingWithETaxi = 'Get moving with E-Taxi';
  static const String byCreating = 'By creating an account, you agree to our';
  static const String termsOfService = 'Terms of Service';
  static const String privacyPolicy = 'Privacy Policy';
  static const String enterMobileNumber = 'Enter your mobile number';
  static const String phoneVerification = 'Phone Verification';
  static const String enterOtp = 'Enter your OTP code below';
  static const String resendCode = 'Resend code in';
  static const String seconds = 'seconds';
}

final LocationSettings locationSettings = AndroidSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 10,
);

class ApiConstants {
  static bool isDev = true;
  static int timeoutSeconds = 20;

  // Local
  static String host = '10.0.2.2'; //192.168.1.5
  static int port = 3002;

  // Remote
  static String remoteHost = "api-driver.hausuper-s.me";
  static int remotePort = 4002;

  // Url
  static String baseUrl = isDev ? 'http://$host:$port/api/v1' : prodUrl;
  static String prodUrl = 'https://$remoteHost/api/v1';

  static String socketUrl = isDev
      ? 'http://$host:3003/drivers'
      : "https://socket.hausuper-s.me/drivers";
}

const topMarginInWelcomeScreen = 150.0;

const minTouchSize = 48.0;

const borderRadiusXSmall = 4.0;
const borderRadiusSmall = 8.0;

const layoutSmall = 8.0;
const layoutMedium = 16.0;
const layoutXMedium = 20.0;
const layoutLarge = 24.0;
const layoutXLarge = 32.0;
const layoutXXLarge = 40.0;

const passwordLength = 6;
const passwordFieldWidth = 50.0;
const passwordTryTimes = 5;

const otpLength = 6;
const otpFieldWidth = 48.0;
const resendOtpTime = 60; // seconds

const smallIcon = 16.0;
const mediumIcon = 24.0;

var baseLoadingColor = Colors.grey[400]!;
var highlightLoadingColor = Colors.grey[200]!;

const shortDuration = Duration(milliseconds: 200);
const mediumDuration = Duration(milliseconds: 400);
const longDuration = Duration(milliseconds: 500);

var passwordRegExp =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$');
