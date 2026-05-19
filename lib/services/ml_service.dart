import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MlService {
  static const String _baseUrl = 'https://sirghazian-auklus-backend.hf.space';

  // --- klasifikasi klausul via ml backend ---
  static Future<List<dynamic>> analyzeClauses(String requestText) async {
    final List<String> sentences = requestText
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (sentences.isEmpty) {
      return [];
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'sentences': sentences}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results'] ?? [];
      } else {
        debugPrint('ml api error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('ml api exception: $e');
      return [];
    }
  }
}
