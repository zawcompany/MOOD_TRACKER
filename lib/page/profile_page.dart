import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'logout_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNav(),
      body: Container(
        decoration: _bgGradient(),
        child: SafeArea(
          child: Column(
            children: [
              // Back button + Title
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                "Profile",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 20),

              // Avatar
              const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage("assets/profile.png"),
              ),

              const SizedBox(height: 12),
              const Text("iLa", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text("@nblsalsa", style: TextStyle(fontSize: 14, color: Colors.black54)),

              const SizedBox(height: 16),

              // Edit Profile Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Edit Profile"),
              ),

              const SizedBox(height: 30),

              // Menu Box
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    // CHANGE PASSWORD
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: const Text("Change Password"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                        );
                      },
                    ),
                    const Divider(height: 1),

                    // LOG OUT
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text("Log Out"),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => const LogoutDialog(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Gradient background
  BoxDecoration _bgGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFF8E6F4),
          Color(0xFFE1C9F4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// Bottom Navigation
  Widget _bottomNav() {
    return Container(
      height: 65,
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6)
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.home_outlined, size: 30),
          Icon(Icons.person, size: 30),
        ],
      ),
    );
  }
}