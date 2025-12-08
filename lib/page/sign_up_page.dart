import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import '../../services/auth_service.dart'; 
import 'sign_in_page.dart';
import 'choose_mood.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  final AuthService _authService = AuthService(); // Inisiasi Service
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi.')),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.registerUser(email, password, name);
      
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateProfile(displayName: name); 
      }
      String userName = user?.displayName ?? name; 

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChooseMoodPage(userName: userName), 
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', 'Error Registrasi: ')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE5FF), Color(0xFFF8EFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/welcome_emoji.png',
                    height: size.height * 0.2, 
                  ),
                ),
                const SizedBox(height: 25),

                const Text(
                  "Let’s you sign up",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Begin your journey to know yourself better",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 25),

                _CustomTextField(
                  label: 'Username',
                  icon: Icons.person_outline,
                  controller: _nameController, 
                ),
                _CustomTextField(
                  label: 'Email',
                  icon: Icons.email_outlined,
                  controller: _emailController, 
                  keyboardType: TextInputType.emailAddress,
                ),
                _CustomTextField(
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  controller: _passwordController, 
                ),
                _CustomTextField(
                  label: 'Confirm Password',
                  icon: Icons.lock_person_outlined,
                  obscureText: true,
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8C64D8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isLoading ? null : _handleSignUp,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator(
                              color: Colors.white, 
                              strokeWidth: 2
                            )
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInPage()),
                        );
                      },
                      child: const Text(
                        "Sign in.",
                        style: TextStyle(
                          color: Color(0xFF8C64D8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller; 
  final TextInputType keyboardType; 

  const _CustomTextField({
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.controller, 
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller, 
        keyboardType: keyboardType, 
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10), 
        ),
      ),
    );
  }
}