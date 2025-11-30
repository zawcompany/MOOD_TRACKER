import 'package:flutter/material.dart';

// Import halaman-halaman yang akan ditampilkan
import 'dashboard/presentation/screens/dashboard_screen.dart'; // [Dashboard]
import 'profile_page.dart';                                   // [Profile Page]
// Import CustomNavbar yang sudah Anda buat
import 'widgets/custom_navbar.dart'; 


class CustomNavbarScreen extends StatefulWidget {
  const CustomNavbarScreen({super.key});

  @override
  State<CustomNavbarScreen> createState() => _CustomNavbarScreenState();
}

class _CustomNavbarScreenState extends State<CustomNavbarScreen> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan di Body
  final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(), // Index 0
    const ProfilePage(),      // Index 1
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan menampilkan halaman yang dipilih (Dashboard atau Profile)
      body: _widgetOptions.elementAt(_selectedIndex), 

      // Panggil CustomNavbar Anda sebagai bottom navigation bar
      bottomNavigationBar: CustomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}