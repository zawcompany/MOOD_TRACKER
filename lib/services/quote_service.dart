import 'dart:convert';
import 'package:http/http.dart' as http; 

class QuoteModel {
  final String content;
  final String author;
  
  QuoteModel({required this.content, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(

      content: json['content'] ?? 'Quote not available.',
      author: json['author'] ?? 'Unknown Author',
    );
  }
}

class QuoteService {
  final String _apiUrl = 'https://api.quotable.io/random';
  
  // Kutipan default (fallback) jika API gagal
  final QuoteModel _defaultQuote = QuoteModel(
    content: "The future belongs to those who believe in the beauty of their dreams.",
    author: "Eleanor Roosevelt",
  );

  Future<QuoteModel> fetchRandomQuote({String moodType = 'positive'}) async {
    String tag;
    if (moodType == 'negative') {
        tag = 'inspirational|life'; 
    } else {
        tag = 'happiness|motivational'; 
    }
    final uri = Uri.parse('$_apiUrl?tags=$tag'); 
    
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return QuoteModel.fromJson(jsonResponse); 
      } else {
        return _defaultQuote; 
      }
    } catch (e) {
      return _defaultQuote;
    }
  }
}