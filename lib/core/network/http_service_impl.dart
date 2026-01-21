import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'http_service.dart';

class HttpServiceImpl implements HttpService {
  final http.Client client;
  final Duration timeout;

  HttpServiceImpl({
    required this.client,
    this.timeout = const Duration(seconds: 15),
  });

  Map<String, String> _defaultHeaders(Map<String, String>? headers) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };
  }

  @override
  Future<Map<String, dynamic>> get(
      String url, {
        Map<String, String>? headers,
        Map<String, dynamic>? queryParams,
      }) async {
    try {
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await client
          .get(uri, headers: _defaultHeaders(headers))
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timeout');
    }
  }

  @override
  Future<Map<String, dynamic>> post(
      String url, {
        Map<String, String>? headers,
        Object? body,
      }) async {
    try {
      final response = await client
          .post(
        Uri.parse(url),
        headers: _defaultHeaders(headers),
        body: jsonEncode(body),
      )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timeout');
    }
  }

  @override
  Future<Map<String, dynamic>> put(
      String url, {
        Map<String, String>? headers,
        Object? body,
      }) async {
    try {
      final response = await client
          .put(
        Uri.parse(url),
        headers: _defaultHeaders(headers),
        body: jsonEncode(body),
      )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timeout');
    }
  }

  @override
  Future<Map<String, dynamic>> delete(
      String url, {
        Map<String, String>? headers,
      }) async {
    try {
      final response = await client
          .delete(
        Uri.parse(url),
        headers: _defaultHeaders(headers),
      )
          .timeout(timeout);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(response.body);
      }else{
        return _handleResponse(response);      }
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timeout');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception(response.body);
    }
  }
}
