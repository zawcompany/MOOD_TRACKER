// lib/page/dashboard/presentation/widgets/quote_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/dashboard_provider.dart'; // PERBAIKAN: Path import relatif
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menggunakan Selector agar hanya me-rebuild ketika _quoteOfTheDay berubah
    final quote = context.select((DashboardProvider p) => p.quoteOfTheDay);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.1), blurRadius: 10)]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(FontAwesomeIcons.quoteLeft, size: 18, color: Colors.grey.shade400),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  quote, // Data diambil dari Provider
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
              FaIcon(FontAwesomeIcons.quoteRight, size: 18, color: Colors.grey.shade400),
            ],
          ),
          SizedBox(height: 10),
          // Contoh tombol untuk refresh state
          TextButton(
            onPressed: () => context.read<DashboardProvider>().refreshQuote(),
            child: Text("Refresh Quote", style: TextStyle(color: Colors.pink)),
          )
        ],
      ),
    );
  }
}