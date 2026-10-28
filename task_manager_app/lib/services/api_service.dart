import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/task.dart';

/// Thrown when the API returns a non-success status code or the network fails.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json', // Critical: forces JSON error responses
  };

  static Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  /// Wraps any HTTP request with timeout + generic error catching.
  static Future<http.Response> _safeRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request().timeout(ApiConfig.timeout);
      return response;
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(0, 'Network error: $e');
    }
  }

  /// Asserts the response status is in [expected]; throws [ApiException] otherwise.
  static void _assertSuccess(http.Response res, List<int> expected) {
    if (!expected.contains(res.statusCode)) {
      try {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final msg = body['message'] as String? ?? 'Unknown error';
        throw ApiException(res.statusCode, msg);
      } on FormatException {
        throw ApiException(res.statusCode, 'Unexpected server response');
      }
    }
  }

  // ── GET /api/tasks ─────────────────────────────────────────────────────────
  static Future<List<Task>> getTasks() async {
    final res = await _safeRequest(
      () => http.get(_uri('/tasks'), headers: _headers),
    );
    _assertSuccess(res, [200]);
    final List<dynamic> data = jsonDecode(res.body);
    return data.map((j) => Task.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ── GET /api/tasks/{id} ────────────────────────────────────────────────────
  static Future<Task> getTask(int id) async {
    final res = await _safeRequest(
      () => http.get(_uri('/tasks/$id'), headers: _headers),
    );
    _assertSuccess(res, [200]);
    return Task.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  // ── POST /api/tasks ────────────────────────────────────────────────────────
  static Future<Task> createTask(Map<String, dynamic> data) async {
    final res = await _safeRequest(
      () => http.post(
        _uri('/tasks'),
        headers: _headers,
        body: jsonEncode(data),
      ),
    );
    _assertSuccess(res, [201]);
    return Task.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  // ── PATCH /api/tasks/{id} ──────────────────────────────────────────────────
  static Future<Task> updateTask(int id, Map<String, dynamic> data) async {
    final res = await _safeRequest(
      () => http.patch(
        _uri('/tasks/$id'),
        headers: _headers,
        body: jsonEncode(data),
      ),
    );
    _assertSuccess(res, [200]);
    return Task.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  // ── DELETE /api/tasks/{id} ─────────────────────────────────────────────────
  static Future<void> deleteTask(int id) async {
    final res = await _safeRequest(
      () => http.delete(_uri('/tasks/$id'), headers: _headers),
    );
    _assertSuccess(res, [200]);
  }
}

