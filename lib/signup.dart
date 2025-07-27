import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication package
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Controllers to retrieve user input from text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Used for live password rule checking
  String password = '';

  // Flags to show/hide password fields
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // --- Password Validation Rules ---
  bool get isLengthValid => password.length >= 8; // At least 8 characters
  bool get hasUpperAndLower =>
      RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(password); // Must contain uppercase & lowercase
  bool get hasSpecialChar =>
      RegExp(r'[!@#\$%\^&\*]').hasMatch(password); // Must contain a special character

  // Builds a row showing if a password rule is met or not
  Widget _buildRule(String text, bool passed) {
    return Row(
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.cancel, // Shows check or cross icon
          color: passed ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: passed ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // --- Firebase Signup Function ---
  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final passwordText = _passwordController.text.trim();
    final confirmPasswordText = _confirmPasswordController.text.trim();

    // Check if any field is empty
    if (email.isEmpty || passwordText.isEmpty || confirmPasswordText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required.")),
      );
      return;
    }

    // Check if passwords match
    if (passwordText != confirmPasswordText) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    // Validate password rules
    if (!isLengthValid || !hasUpperAndLower || !hasSpecialChar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fix the password requirements.")),
      );
      return;
    }

    try {
      // Firebase signup using email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: passwordText,
      );

      // Navigate to home after successful signup
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase signup errors
      String errorMessage = "Signup failed.";
      if (e.code == 'email-already-in-use') {
        errorMessage = "Email already in use.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password too weak.";
      }

      // Display error message in snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --- App Bar ---
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(192, 204, 218, 1),
        centerTitle: true,
        title: Text(
          "KENKO",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: const Color.fromRGBO(66, 76, 90, 1),
          ),
        ),
      ),

      // --- Body ---
      body: SafeArea(
        child: SingleChildScrollView( // Allows scrolling on smaller screens
          child: Column(
            children: [
              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Email TextField ---
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 20),

                    // --- Password TextField ---
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword, // Hide text if true
                      onChanged: (val) {
                        setState(() {
                          password = val; // Updates password to check rules live
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off // Hidden state icon
                                : Icons.visibility,    // Visible state icon
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 20),

                    // --- Confirm Password TextField ---
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 30),

                    // --- Password Rules Section ---
                    const Text(
                      "Password must contain:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildRule("8 or more characters", isLengthValid),
                    _buildRule("At least 1 uppercase & 1 lowercase", hasUpperAndLower),
                    _buildRule("1 special character (!@#\$%^&*)", hasSpecialChar),
                    const SizedBox(height: 30),

                    // --- Signup Button ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(66, 76, 90, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _signup, // Calls signup function
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Navigate to Login ---
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Login()),
                      ),
                      child: const Center(
                        child: Text(
                          "Already have an account? Log in",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
