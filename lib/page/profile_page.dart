import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../page/edit_profile_page.dart';
import '../page/change_password_page.dart';
import '../page/logout_dialog.dart';
import 'package:mood_tracker/page/widgets/custom_navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavbar(
        currentIndex: 1,
        onTap: (i) {
          if (i == 1) return;
          Navigator.pushNamed(context, "/dashboard");
        },
      ),
      body: Container(
        decoration: _bgGradient(),
        child: SafeArea(
          child: FutureBuilder<ProfileData>(
            future: AuthService().fetchProfileData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: Text(
                    "Gagal memuat profil: ${snapshot.error ?? 'Data Kosong'}",
                  ),
                );
              }

              final data = snapshot.data!;

              return _buildProfileContent(context, data);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileData data) {
    return SingleChildScrollView(
      child: Column(
        children: [
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

          const CircleAvatar(
            radius: 55,
            backgroundImage: AssetImage("assets/profile.png"),
          ),

          const SizedBox(height: 12),

          Text(
            data.fullName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          Text(
            data.username ?? 'No Username',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),

          const SizedBox(height: 16),

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

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text("Change Password"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),

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
    );
  }

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
}
