import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteModel {
  final String content;
  final String author;

  QuoteModel({required this.content, required this.author});
}

class QuoteService {
  final String apiKey = 'hrzXppj52avRe/RhaCaDAg==QtCnrJOnLBoL3jzg';
  final String baseUrl = 'https://api.api-ninjas.com/v1/quotes';

  Future<QuoteModel> fetchRandomQuote() async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(
        url,
        headers: {'X-Api-Key': apiKey},
      );

      print('STATUS CODE: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final jsonData = jsonDecode(response.body)[0];

        return QuoteModel(
          content: jsonData['quote'] ?? 'Quote not available',
          author: jsonData['author'] ?? 'Unknown Author',
        );
      }
    } catch (e) {
      print('ERROR: $e');
    }

    return QuoteModel(
      content: 'Stay strong. Better days are coming.',
      author: 'Unknown',
    );
  }
}