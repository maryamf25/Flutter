import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_screen.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)], // Same Gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_person_outlined, size: 80, color: Colors.white.withOpacity(0.9)),
                const SizedBox(height: 10),
                Text(
                  "Welcome Back",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign in to continue",
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 40),

                // Inputs
                _buildTextField(_usernameController, "Username", Icons.person),
                const SizedBox(height: 16),
                _buildTextField(_emailController, "Email", Icons.email),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White button pops on gradient
                      foregroundColor: const Color(0xFF764BA2), // Purple Text
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      String username = _usernameController.text.trim();
                      String email = _emailController.text.trim();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            username: username.isEmpty ? "User" : username,
                            email: email.isEmpty ? "user@example.com" : email,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.white60),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15), // Glass effect
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}