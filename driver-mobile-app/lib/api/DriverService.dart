import 'package:http/http.dart' as http;

import 'package:grab_eat_ui/api/ApiClient.dart';
import 'package:grab_eat_ui/utils/app_constants.dart';

class DriverService {
  static final String _endpoint = "${ApiConstants.baseUrl}/drivers";
  // static final String _bookEndpoint = "${ApiConstants.baseUrl}/booking-system";
  static final ApiClient _client = ApiClient();

  static Future<http.Response> getHistory() {
    print("GET");
    return _client.get(Uri.parse("$_endpoint/history"), headers: {
      "Content-Type": "application/json",
    });
  }
}
