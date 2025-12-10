import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // controllers untuk data profil
  final TextEditingController _photoUrlController = TextEditingController(); 
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  // state untuk tampilan
  String? _currentPhotoUrl;
  String _gender = "Male";
  DateTime? _selectedDate;
  bool _isLoading = false;
  bool _isProfileLoading = true;

  final Color _purpleBorderColor = const Color.fromARGB(177, 142, 120, 179);

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  /// mengambil data profil dari firebase saat halaman dimuat.
  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) setState(() => _isProfileLoading = false);
      return;
    }

    _emailController.text = user.email ?? '';
    // mengambil photo url dari firebase auth
    _currentPhotoUrl = user.photoURL;
    // mengisi controller url dengan foto lama
    _photoUrlController.text = user.photoURL ?? ''; 

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        _phoneController.text = data['phone'] ?? '';
        _gender = data['gender'] ?? 'Male';
        _usernameController.text = data['username'] ?? user.displayName ?? '';

        if (data['birthday'] is Timestamp) {
          _selectedDate = (data['birthday'] as Timestamp).toDate();
          _birthdayController.text =
              "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
        }
      } else {
        _usernameController.text = user.displayName ?? '';
      }
    } catch (e) {
      debugPrint("error loading profile data: $e");
    } finally {
      if (mounted) setState(() => _isProfileLoading = false);
    }
  }


  /// menangani proses penyimpanan (update) profil.
  /// operasi ini tidak melakukan upload file, hanya menyimpan string url.
  Future<void> _handleSave() async {
    if (_usernameController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('username tidak boleh kosong.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (mounted) setState(() => _isLoading = true);

    try {
      final String newPhotoUrl = _photoUrlController.text.trim();
      
      // 1. update photo url di firebase auth (cepat)
      if (newPhotoUrl.isNotEmpty) {
          await user.updatePhotoURL(newPhotoUrl); 
      } else {
          // jika field dikosongkan, url dihapus
          await user.updatePhotoURL(null); 
      }
      
      // 2. update display name (firebase auth)
      await _authService.updateUserData(
        name: _usernameController.text.trim(),
        email: _emailController.text.trim(),
      );

      // 3. update data firestore
      final Map<String, dynamic> firestoreUpdates = {
        'phone': _phoneController.text.trim(),
        'gender': _gender,
        'username': _usernameController.text.trim(),
        'birthday':
            _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
        // menyimpan url juga di firestore
        'photoUrl': newPhotoUrl, 
      };

      await _firestore.collection('users').doc(user.uid).update(firestoreUpdates);

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('profil berhasil diperbarui!')),
      );
      // mengirim sinyal 'true' kembali ke halaman profile
      Navigator.pop(context, true); 
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('gagal memperbarui profil: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// menampilkan date picker untuk memilih tanggal lahir.
  Future<void> _pickBirthday() async {
    final pick = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2003),
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
    );

    if (pick != null && mounted) {
      setState(() {
        _selectedDate = pick;
        _birthdayController.text =
            "${pick.day}/${pick.month}/${pick.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    // memperbarui currentPhotoUrl secara real-time dari input field untuk preview
    if (_photoUrlController.text.trim().isNotEmpty) {
        _currentPhotoUrl = _photoUrlController.text.trim();
    } else if (_photoUrlController.text.trim().isEmpty) {
        _currentPhotoUrl = null;
    }
    
    if (_isProfileLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      decoration: _bgGradient(),
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        body: SafeArea(
          child: Column(
            children: [
              // header
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.black,
                    ),
                    const Expanded(
                      child: Text(
                        "edit profile",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // formulir
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [

                      // tampilan foto profil (read-only dari url)
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: _currentPhotoUrl != null && _currentPhotoUrl!.isNotEmpty
                            ? NetworkImage(_currentPhotoUrl!) as ImageProvider
                            : const AssetImage("assets/images/profileMT.jpg"),
                      ),
                      
                      const SizedBox(height: 25),

                      // input field untuk url foto
                      _input("photo url", _photoUrlController),
                      const SizedBox(height: 12),
                      
                      // input fields lainnya
                      _input("username", _usernameController), 
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _gender,
                              items: const [
                                DropdownMenuItem(value: "Male", child: Text("male")),
                                DropdownMenuItem(
                                    value: "Female", child: Text("female")),
                              ],
                              decoration: _inputDec("gender"),
                              onChanged: (v) => setState(() => _gender = v!),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _birthdayController,
                              readOnly: true,
                              decoration: _inputDec("birthday"),
                              onTap: _pickBirthday,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      _input("phone number", _phoneController),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _emailController,
                        readOnly: true,
                        decoration: _inputDec("email (tidak dapat diedit)"),
                      ),

                      const SizedBox(height: 10), 
                    ],
                  ),
                ),
              ),

              // button save
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isLoading ? null : _handleSave,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Text("save",
                            style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _input(String label, TextEditingController c) {
    return TextField(
      controller: c,
      decoration: _inputDec(label),
    );
  }

  InputDecoration _inputDec(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _purpleBorderColor, width: 1.0), 
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _purpleBorderColor, width: 1.0), 
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _purpleBorderColor, width: 1.0), 
      ),
      filled: true,
      fillColor: const Color(0xFFF1E6F7), 
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