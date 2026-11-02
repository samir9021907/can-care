import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String? _authToken;

  Future<String?> getAuthToken() async {
    if (_authToken != null) return _authToken;
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(ApiConstants.tokenKey);
    return _authToken;
  }

  Future<void> saveAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.tokenKey, token);
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConstants.tokenKey);
  }

  Map<String, String> _buildHeaders({bool isJson = true, String? token}) {
    final headers = <String, String>{};
    if (isJson) {
      headers['Content-Type'] = 'application/json';
    }
    final effectiveToken = token ?? _authToken;
    if (effectiveToken != null && effectiveToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $effectiveToken';
    }
    return headers;
  }

  Future<dynamic> get(String url, {Map<String, String>? queryParams}) async {
    await getAuthToken();
    Uri uri = Uri.parse(url);
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    try {
      final response = await http
          .get(uri, headers: _buildHeaders())
          .timeout(const Duration(seconds: 15));

      return _processResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] GET error on $url: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    await getAuthToken();
    final uri = Uri.parse(url);

    try {
      final response = await http
          .post(uri, headers: _buildHeaders(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 20));

      return _processResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] POST error on $url: $e');
      rethrow;
    }
  }

  Future<dynamic> postMultipart({
    required String url,
    required String filePath,
    Map<String, String>? fields,
  }) async {
    await getAuthToken();
    final uri = Uri.parse(url);

    try {
      final request = http.MultipartRequest('POST', uri);
      final headers = _buildHeaders(isJson: false);
      request.headers.addAll(headers);

      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Attach file
      final file = File(filePath);
      if (await file.exists()) {
        final multipartFile = await http.MultipartFile.fromPath('file', filePath);
        request.files.add(multipartFile);
      } else {
        throw Exception('Image file not found at path: $filePath');
      }

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 35));
      final response = await http.Response.fromStream(streamedResponse);

      return _processResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] Multipart error on $url: $e');
      rethrow;
    }
  }

  Future<dynamic> delete(String url) async {
    await getAuthToken();
    final uri = Uri.parse(url);

    try {
      final response = await http
          .delete(uri, headers: _buildHeaders())
          .timeout(const Duration(seconds: 15));

      return _processResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] DELETE error on $url: $e');
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    final status = response.statusCode;
    final bodyString = response.body;

    dynamic jsonBody;
    try {
      jsonBody = jsonDecode(bodyString);
    } catch (_) {
      jsonBody = null;
    }

    if (status >= 200 && status < 300) {
      return jsonBody ?? bodyString;
    }

    // Extract detail error message if available
    String errorMessage = 'Server error ($status)';
    if (jsonBody is Map && jsonBody.containsKey('detail')) {
      final detail = jsonBody['detail'];
      if (detail is String) {
        errorMessage = detail;
      } else if (detail is List && detail.isNotEmpty) {
        errorMessage = detail.first['msg'] ?? detail.toString();
      }
    } else if (bodyString.isNotEmpty) {
      errorMessage = bodyString;
    }

    throw Exception(errorMessage);
  }
}

