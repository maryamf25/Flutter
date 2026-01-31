import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 22),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 18, 49, 57), Color(0xFF0891B2)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Avatar
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0891B2),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: Text(
                  user?.email?[0].toUpperCase() ?? 'U',
                  style: GoogleFonts.poppins(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0891B2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Email
            Text(
              user?.email ?? 'No email',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Member since ${user?.metadata.creationTime?.year ?? 'N/A'}',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 18, 49, 57),
                      Color(0xFF0891B2),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // IMPORTANT
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout),
                      const SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
