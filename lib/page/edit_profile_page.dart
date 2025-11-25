import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? genderValue;
  DateTime? selectedDate;

  final nameController = TextEditingController(text: "Bila");
  final emailController = TextEditingController(text: "bila@gmail.com");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage("assets/profile.png"),
            ),
            const SizedBox(height: 20),

            _inputField("Name", nameController),
            const SizedBox(height: 16),

            _inputField("Email", emailController),
            const SizedBox(height: 16),

            // Gender Dropdown
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Gender"),
              value: genderValue,
              items: ["Male", "Female"]
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) {
                setState(() => genderValue = v);
              },
            ),
            const SizedBox(height: 16),

            // Birthday Date Picker
            TextFormField(
              readOnly: true,
              decoration: _inputDecoration("Birthday").copyWith(
                suffixIcon: const Icon(Icons.calendar_month),
              ),
              controller: TextEditingController(
                text: selectedDate == null
                    ? ""
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              ),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2003),
                  firstDate: DateTime(1960),
                  lastDate: DateTime(2030),
                );

                if (date != null) {
                  setState(() => selectedDate = date);
                }
              },
            ),

            const SizedBox(height: 40),

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
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration(label),
    );
  }
}
