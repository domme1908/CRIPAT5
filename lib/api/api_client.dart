import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class APIClient {
  final httpClient = http.Client();

  Future<dynamic> fetchJSON(Uri url) async {
    return jsonDecode(await fetch(url));
  }

  Future<String> fetch(Uri url) async {
    if (kDebugMode) {
      debugPrint("Fetching URL ${url.toString()}");
    }

    // At first, we try to get the response by fetching it from the web server
    var response = await httpClient.get(url, headers: {
      "Accept": "application/json",
      "User-Agent": "cri_pat_5",
    }).timeout(const Duration(seconds: 10));

    if (kDebugMode) {
      debugPrint(
          "Got response for ${url.toString()}: status ${response.statusCode}");
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException("Unexpected status code ${response.statusCode}");
    }

    return utf8.decode(response.bodyBytes);
  }
}
