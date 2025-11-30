import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home_outlined,
                size: 30,
                color: currentIndex == 0 ? Colors.purple : Colors.black54),
            onPressed: () => onTap(0),
          ),
          IconButton(
            icon: Icon(Icons.person,
                size: 30,
                color: currentIndex == 1 ? Colors.purple : Colors.black54),
            onPressed: () => onTap(1),
          ),
        ],
      ),
    );
  }
}