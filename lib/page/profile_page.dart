import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../page/edit_profile_page.dart';
import '../page/change_password_page.dart';
import '../page/logout_dialog.dart';

// ubah menjadi StatefulWidget untuk mengelola refresh data
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ProfileData> _profileDataFuture;

  @override
  void initState() {
    super.initState();
    _profileDataFuture = AuthService().fetchProfileData();
  }

  void _refreshProfile() {
    setState(() {
      _profileDataFuture = AuthService().fetchProfileData();
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';

    return DateFormat('dd/MM/yyyy').format(date);
  }

  Widget _buildProfileDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? "N/A" : value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _bgGradient(),
        child: SafeArea(
          child: FutureBuilder<ProfileData>(
            future: _profileDataFuture,
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
    debugPrint("Profile Page: Fetched Photo URL: ${data.photoUrl}");

    ImageProvider profileImage;
    if (data.photoUrl != null && data.photoUrl!.isNotEmpty) {
      profileImage = NetworkImage(data.photoUrl!);
    } else {
      profileImage = const AssetImage("assets/images/profileMT.jpg");
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Profile",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          CircleAvatar(radius: 55, backgroundImage: profileImage),
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
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
              _refreshProfile();
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xCCFFFFFF),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x0D000000),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProfileDetailRow(
                  "Email",
                  data.email,
                  Icons.email_outlined,
                ),
                _buildProfileDetailRow(
                  "Nomor Telepon",
                  data.phone ?? 'N/A',
                  Icons.phone_outlined,
                ),
                _buildProfileDetailRow(
                  "Jenis Kelamin",
                  data.gender ?? 'N/A',
                  Icons.person_outline,
                ),
                _buildProfileDetailRow(
                  "Tanggal Lahir",
                  _formatDate(data.birthday),
                  Icons.calendar_today_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xCCFFFFFF),
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  BoxDecoration _bgGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFF8E6F4), Color(0xFFE1C9F4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}