// quote_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteModel {
  final String content;
  final String author;

  QuoteModel({required this.content, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      content: json['content'] ?? 'No quote available',
      author: json['author'] ?? 'Unknown',
    );
  }
}

class QuoteService {
  final String baseUrl = 'https://quoteslate.vercel.app/api/quotes/random?count=1';

  Future<QuoteModel> fetchRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List && decoded.isNotEmpty) {
          return QuoteModel.fromJson(decoded[0]);
        }
      }
    } catch (e) {
      print("ERROR FETCHING QUOTE: $e");
    }

    // fallback kalau gagal
    return QuoteModel(
      content: "Keep going — stay strong!",
      author: "Unknown",
    );
  }
}
