import 'package:flutter/material.dart';
import 'dashboard/presentation/screens/dashboard_screen.dart'; 
import 'profile_page.dart';                     
import 'widgets/custom_navbar.dart'; 


class CustomNavbarScreen extends StatefulWidget {
  const CustomNavbarScreen({super.key});

  @override
  State<CustomNavbarScreen> createState() => _CustomNavbarScreenState();
}

class _CustomNavbarScreenState extends State<CustomNavbarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(), 
    const ProfilePage(),    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex), 

      bottomNavigationBar: CustomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}