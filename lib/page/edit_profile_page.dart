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

  final TextEditingController _usernameController = TextEditingController(); 
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  String _gender = "Male";
  DateTime? _selectedDate;
  bool _isLoading = false;
  bool _isProfileLoading = true;

  // definisikan warna ungu untuk border
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
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) setState(() => _isProfileLoading = false);
      return;
    }

    _emailController.text = user.email ?? '';

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
      debugPrint("Error loading profile data: $e");
    } finally {
      if (mounted) setState(() => _isProfileLoading = false);
    }
  }

  Future<void> _handleSave() async {
    if (_usernameController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username tidak boleh kosong.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (mounted) setState(() => _isLoading = true);

    try {
      await _authService.updateUserData(
        name: _usernameController.text.trim(), 
        email: _emailController.text.trim(),
      );

      await _firestore.collection('users').doc(user.uid).update({
        'phone': _phoneController.text.trim(),
        'gender': _gender,
        'username': _usernameController.text.trim(),
        'birthday':
            _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
      });

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );
      Navigator.pop(context); 
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
              // headernya (button back dan title)
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
                        "Edit Profile",
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
                      // Profile Picture
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 55,
                            backgroundImage: AssetImage("assets/images/profileMT.jpg"),
                          ),
                          Positioned(
                            right: 6,
                            bottom: 6,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit,
                                  color: Colors.white, size: 18),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 25),

                      // input Fields
                      _input("Username", _usernameController), 
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _gender,
                              items: const [
                                DropdownMenuItem(value: "Male", child: Text("Male")),
                                DropdownMenuItem(
                                    value: "Female", child: Text("Female")),
                              ],
                              decoration: _inputDec("Gender"),
                              onChanged: (v) => setState(() => _gender = v!),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _birthdayController,
                              readOnly: true,
                              decoration: _inputDec("Birthday"),
                              onTap: _pickBirthday,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      _input("Phone number", _phoneController),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _emailController,
                        readOnly: true,
                        decoration: _inputDec("Email (tidak dapat diedit)"),
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
                        : const Text("Save",
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
      // Styling untuk border yang fokus (saat diklik)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _purpleBorderColor, width: 1.0), 
      ),
      // Styling untuk border normal (saat tidak fokus)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _purpleBorderColor, width: 1.0), 
      ),

      // Styling untuk border default 
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