import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String gender = "Male";
  DateTime? selectedDate;

  final nameC = TextEditingController(text: "iLa");
  final phoneC = TextEditingController(text: "+62 81234567890");
  final emailC = TextEditingController(text: "olaamigos@gmail.com");
  final usernameC = TextEditingController(text: "@nblsalsa");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNav(),
      body: Container(
        decoration: _bgGradient(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Back + title
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),

                const Text(
                  "Edit profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 20),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage("assets/profile.png"),
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
                        child: const Icon(Icons.edit, color: Colors.white, size: 18),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 25),

                _input("Full name", nameC),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        value: gender,
                        items: const [
                          DropdownMenuItem(value: "Male", child: Text("Male")),
                          DropdownMenuItem(value: "Female", child: Text("Female")),
                        ],
                        decoration: _inputDec("Gender"),
                        onChanged: (v) => setState(() => gender = v!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: _inputDec("Birthday"),
                        controller: TextEditingController(
                          text: selectedDate == null
                              ? "Male"
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        ),
                        onTap: _pickBirthday,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                _input("Phone number", phoneC),
                const SizedBox(height: 12),
                _input("Email", emailC),
                const SizedBox(height: 12),
                _input("User name", usernameC),

                const SizedBox(height: 30),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Save", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  _pickBirthday() async {
    final pick = await showDatePicker(
      context: context,
      initialDate: DateTime(2003),
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
    );
    if (pick != null) setState(() => selectedDate = pick);
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

  Widget _bottomNav() {
    return Container(
      height: 65,
      decoration: const BoxDecoration(color: Colors.white),
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