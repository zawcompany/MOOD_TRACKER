import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Import widgets
import '../widgets/weekly_mood_row.dart';
import '../widgets/quote_card.dart'; 
// Import Detail Mood Screen
import 'detail_mood_screen.dart';

// Diubah menjadi StatefulWidget untuk mengelola BottomNavigationBar
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // State untuk Bottom Navbar (0=Home/Dashboard, 1=Profile)
  int _selectedIndex = 0; 
  
  // Daftar halaman untuk Bottom Navbar
  static final List<Widget> _pages = <Widget>[
    // Halaman 0: Konten Dashboard
    _DashboardContent(),
    // Halaman 1: Placeholder Profile (Ubah Profile & Logout)
    const Center(child: Text("Halaman Profil (Ubah Profile & Logout)", style: TextStyle(fontSize: 18))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      
      // Tombol 'Lihat Mood' sebagai FloatingActionButton
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0), 
        child: ElevatedButton(
          onPressed: () {
            // Navigasi ke halaman Detail Mood
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DetailMoodScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(180, 50), // Ukuran tombol
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 8,
          ),
          child: const Text('Lihat Mood', style: TextStyle(color: Colors.white)),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // Warna ikon aktif
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showSelectedLabels: false, 
        showUnselectedLabels: false,
      ),
    );
  }
}

// Widget Konten Dashboard (Dipisahkan dari DashboardScreen)
class _DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return Container(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
        // Tambahkan gradien sesuai desain Anda
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50.withOpacity(0.5), Colors.pink.shade50.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hey, iLa', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            // Weekly Mood
            const Text('Your Weekly Mood', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            const Center(child: WeeklyMoodRow()), 
            const SizedBox(height: 40),

            // Quote of the Day
            const Text('Quote of the Day', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            QuoteCard(), 
            const Spacer(),
            
            // Placeholder untuk jarak ke Floating Button / BottomNavbar
            const SizedBox(height: 60), 
          ],
        ),
      );
  }
}