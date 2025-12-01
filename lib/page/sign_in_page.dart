import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import '../../services/auth_service.dart';
import 'custom_navbar_screen.dart';
import 'sign_up_page.dart';
import 'choose_mood.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controller dan State
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Inisiasi Service
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password harus diisi.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      final User? user = FirebaseAuth.instance.currentUser;
      String userName = user?.displayName ?? 'Pengguna'; 

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChooseMoodPage(userName: userName), 
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', 'Error Login: ')),
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
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8EFFF), Color(0xFFEDE5FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.08,
              vertical: height * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/welcome_emoji.png',
                    height: height * 0.25,
                  ),
                ),
                SizedBox(height: height * 0.04),

                const Text(
                  "Let’s you sign in",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Welcome back, you have been missed",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: height * 0.03),

                // Text Field untuk EMAIL
                _CustomTextField(
                  label: 'Email', 
                  icon: Icons.email_outlined,
                  controller: _emailController, 
                  keyboardType: TextInputType.emailAddress,
                ),
                // Text Field untuk PASSWORD
                _CustomTextField(
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  controller: _passwordController, 
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Halaman Forget Password
                    },
                    child: const Text(
                      "Forget Password?",
                      style: TextStyle(color: Color(0xFF8C64D8)),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.01),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8C64D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize: Size(double.infinity, height * 0.06),
                    shadowColor: Colors.purple.withOpacity(0.3),
                    elevation: 4,
                  ),

                  onPressed: _isLoading ? null : _handleSignIn,
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
                          "Sign in",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),

                SizedBox(height: height * 0.02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        "Create one.",
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
        color: Colors.white.withOpacity(0.85),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 15), 
        ),
      ),
    );
  }
}