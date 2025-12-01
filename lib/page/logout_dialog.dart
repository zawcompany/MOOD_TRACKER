import 'package:flutter/material.dart';
import '../page/welcome_page.dart';
import '../../services/auth_service.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Are you sure to Log out\nthis account?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // YES (Logout)
              TextButton(
                onPressed: () async {
                  try {
                    await AuthService().signOut();

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal Logout: ${e.toString()}'),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.pink),
                ),
              ),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
