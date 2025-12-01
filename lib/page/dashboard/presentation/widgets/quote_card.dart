import 'package:flutter/material.dart';
import '../../../../../services/quote_service.dart'; 

class QuoteCard extends StatefulWidget {
  const QuoteCard({super.key});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  // [STATE BARU]: Future dan Service
  late Future<QuoteModel> _quoteFuture;
  final QuoteService _quoteService = QuoteService();

  @override
  void initState() {
    super.initState();
    _quoteFuture = _quoteService.fetchRandomQuote();
  }

  Widget _buildQuoteContent(String quote, String author, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.format_quote_rounded, color: Colors.white, size: 28),
        const SizedBox(height: 10),
        Text(
          quote,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            author,
            style: TextStyle(
              color: color.withOpacity(0.7),
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
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF8C64D8).withOpacity(0.9), 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      
      child: FutureBuilder<QuoteModel>(
        future: _quoteFuture,
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ),
            );
          }

          // 2. Error State 
          if (snapshot.hasError) {
            return _buildQuoteContent(
              "Gagal memuat quote.",
              "Error: Cek koneksi atau API",
              Colors.white, 
            );
          }

          // 3. Data Loaded
          if (snapshot.hasData) {
            final quote = snapshot.data!;
            return _buildQuoteContent(
              '${quote.content}',
              '- ${quote.author}',
              Colors.white,
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}