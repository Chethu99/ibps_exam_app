import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> signInWithGoogle(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      UserCredential? userCredential;

      if (kIsWeb) {
        // --- WEB FLOW ---
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // --- MOBILE FLOW (Android) ---
        // 1. Initialize Google Sign In with your WEB Client ID
        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId:
              '516144800433-oe61mqinbkndjh0radc7i7f6ae6eof9p.apps.googleusercontent.com',
        );

        // 2. Trigger native account picker
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          setState(() => _isLoading = false);
          return;
        }

        // 3. Get Auth Details
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // 4. Create Firebase Credential
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // 5. Sign in to Firebase
        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
      }

      if (userCredential.user != null && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Catch specific Firebase Errors
      debugPrint("Firebase Auth Error Code: ${e.code}");
      debugPrint("Firebase Auth Message: ${e.message}");
      _showErrorSnackBar("Firebase Error: ${e.code}");
    } catch (e) {
      // Catch Google Sign In Errors (This is where you'll see Error 10 or 12500)
      debugPrint("Detailed Auth Error: $e");
      _showErrorSnackBar("Login Error. Check Debug Console for code.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF7E8), Color(0xFFF2E3D5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance,
                  size: 80,
                  color: Color(0xFF2F4F8F),
                ),
                const SizedBox(height: 20),
                const Text(
                  "BankEdge",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2F4F8F),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Preparation for Banking & Regulatory Exams",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 50),

                // Button Section
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF2F4F8F))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          elevation: 8,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () => signInWithGoogle(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/google.png",
                              height: 22,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.login, size: 22),
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              "Continue with Google",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                const SizedBox(height: 50),

                const Column(
                  children: [
                    FeatureRow(text: "10,000+ Practice Questions"),
                    FeatureRow(text: "Full Length Mock Tests"),
                    FeatureRow(text: "Smart Performance Analysis"),
                  ],
                ),

                const SizedBox(height: 60),
                const Text(
                  "IBPS • RBI • NABARD • SEBI • LIC",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  final String text;
  const FeatureRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(fontSize: 15, color: Colors.black87)),
        ],
      ),
    );
  }
}
