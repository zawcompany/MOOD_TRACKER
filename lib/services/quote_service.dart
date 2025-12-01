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

  Future<QuoteModel> fetchRandomQuote() async {
    final uri = Uri.parse(_apiUrl);
    
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return QuoteModel.fromJson(jsonResponse); 
      } else {
        throw Exception('Failed to load quote. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to Quote API.');
    }
  }
}