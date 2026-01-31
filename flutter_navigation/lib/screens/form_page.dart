import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
        height: double.infinity, // Fill screen
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)], // Same Gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Icon(
                  Icons.person_add_alt_1,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  "Create Account",
                  style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                const SizedBox(height: 30),

                _buildField("Full Name", Icons.person),
                const SizedBox(height: 16),
                _buildField("Email Address", Icons.email),
                const SizedBox(height: 16),
                _buildField("Password", Icons.lock, isPassword: true),
                const SizedBox(height: 16),
                _buildField("Confirm Password", Icons.lock_outline, isPassword: true),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF764BA2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Register",
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

  Widget _buildField(String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: label,
        hintStyle: GoogleFonts.poppins(color: Colors.white60),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15), // Consistent Glass effect
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }
}