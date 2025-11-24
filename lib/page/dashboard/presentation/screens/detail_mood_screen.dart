import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailMoodScreen extends StatelessWidget {
  const DetailMoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // FIX: Menghilangkan bayangan dan menggunakan warna transparan untuk Appbar bersih
        backgroundColor: Colors.transparent,
        elevation: 0, 
        automaticallyImplyLeading: false, // Kita buat tombol back sendiri
        title: Row(
          children: [
            // Tombol Kembali (<) yang berfungsi untuk pop/kembali ke Dashboard
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
            // Judul Halaman
            const Text('Mood Detail', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        // Tambahkan gradien sesuai desain latar belakang pastel
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50.withOpacity(0.5), Colors.pink.shade50.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10), // Jarak setelah Appbar

              // Bagian Kalender 
              _buildCalendarView(context),
              const SizedBox(height: 30),

              // Bagian Notes (Catatan Mood Harian)
              const Text('Notes:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              _buildNotesCard(),
              
              // Kolom input kosong (sesuai desain)
              const SizedBox(height: 20),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
                ),
              ),
              // FIX KRUSIAL: Menambah jarak di bagian bawah (Bottom Padding) agar tidak overflow
              const SizedBox(height: 50), 
            ],
          ),
        ),
      ),
    );
  }
  // --- Widgets Komponen (Tambahan untuk Detail Mood) ---
  Widget _buildCalendarView(BuildContext context) {
    // Simulasi data kalender
    final List<String> days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]
      ),
      child: Column(
        children: [
          // Navigasi Bulan/Tahun
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios, size: 16), onPressed: () {}),
              const Text('April 2021', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 16), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 15),

          // Header Hari (Mo, Tu, ...)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days.map((day) => Text(day, style: TextStyle(fontWeight: FontWeight.bold, color: day == 'Su' ? Colors.red : Colors.grey.shade600))).toList(),
          ),
          const SizedBox(height: 10),

          // Tampilan Tanggal (menggunakan GridView.builder)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 35, // 5 minggu x 7 hari
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final date = index < 4 ? 29 + index : index - 3; 
              if (index < 4 || date > 30) {
                 return Container(); 
              }
              final isSelected = date == 7;
              
              return GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color.fromARGB(255, 107, 185, 127) : Colors.transparent, 
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    date.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : (index % 7 == 6 ? Colors.red : Colors.black87),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/mood_pink.png', height: 40, width: 40,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.favorite, color: Colors.pink, size: 30),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Text(
              'Aku hari ini lagi happy soalnya kemarin aku makan ice cream.',
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}