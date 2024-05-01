import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/Booking.dart';
import 'ApiClient.dart';

class CustomerService {
  static final String _endpoint = "${ApiConstants.baseUrl}/customers";
  static final String _bookEndpoint = "${ApiConstants.baseUrl}/booking-system";
  static final ApiClient _client = ApiClient();

  static Future<http.Response> bookRide(BookingModel booking) {
    return _client.post(Uri.parse("$_endpoint/book"),
        headers: {
          "Content-Type": "application/json",
        },
        body: booking.toJson());
  }

  static Future<http.Response> calculatePrice(
      String vehicleType, double distance) {
    return _client.get(Uri.parse(
        "$_endpoint/calculate-price?vehicleType=$vehicleType&distance=$distance"));
  }

  static Future<http.Response> getTop5Address(String phoneNumber) {
    return _client.get(Uri.parse("$_bookEndpoint/top-address")
        .replace(queryParameters: {"phoneNumber": phoneNumber}));
  }

  static Future<http.Response> getHistory(String phoneNumber) {
    return _client.get(Uri.parse("$_bookEndpoint/history")
        .replace(queryParameters: {"phoneNumber": phoneNumber}));
  }
}
