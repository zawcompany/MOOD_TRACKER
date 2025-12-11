import 'package:flutter/material.dart';
import '../../../../../services/quote_service.dart';

class QuoteCard extends StatefulWidget {
  final String moodType;

  const QuoteCard({
    super.key,
    required this.moodType,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  late Future<QuoteModel> _quoteFuture;
  final QuoteService _quoteService = QuoteService();

  @override
  void initState() {
    super.initState();
    _quoteFuture = _quoteService.fetchRandomQuote();
  }

  Widget _buildQuoteContent({
    required String quote,
    required String author,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.format_quote_rounded, color: Colors.white, size: 28),
        const SizedBox(height: 10),

        Text(
          quote,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 10),

        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "- $author",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF8C64D8).withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: FutureBuilder<QuoteModel>(
        future: _quoteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildQuoteContent(
              quote: "Failed to load quote.",
              author: "Unknown",
            );
          }

          if (snapshot.hasData) {
            final q = snapshot.data!;
            return _buildQuoteContent(
              quote: q.content,
              author: q.author,
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
