import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication package
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Controllers to retrieve user input from text fields
  final _usernameController = TextEditingController(); // Added for username input
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
  bool get hasUpperAndLower => RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(password); // Must contain uppercase & lowercase
  bool get hasSpecialChar => RegExp(r'[!@#\$%\^&\*]').hasMatch(password); // Must contain a special character

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
    final username = _usernameController.text.trim(); // Get username

    // Check if any field is empty
    if (email.isEmpty || passwordText.isEmpty || confirmPasswordText.isEmpty || username.isEmpty) {
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
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: passwordText,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Save user data including username to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        // Navigate to home after successful signup
        Navigator.pushReplacementNamed(context, '/heightweight');
      }
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
      backgroundColor: const Color.fromRGBO(99, 75, 102, 1),
      // --- Body ---
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
              child: Text(
                "KENKO",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // --- Username TextField ---
                      TextField(
                        controller: _usernameController,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          hintText: "Username",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // --- Email TextField ---
                      TextField(
                        controller: _emailController,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // --- Password TextField ---
                      TextField(
                        controller: _passwordController,
                        textAlign: TextAlign.left,
                        obscureText: _obscurePassword, // Hide text if true
                        onChanged: (val) {
                          setState(() {
                            password = val; // Updates password to check rules live
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off // Hidden state icon
                                  : Icons.visibility, // Visible state icon
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // --- Confirm Password TextField --- 
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // --- Password Rules Section ---
                      const Text(
                        "Password must contain:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildRule("8 or more characters", isLengthValid),
                      _buildRule("At least 1 uppercase & 1 lowercase", hasUpperAndLower),
                      _buildRule("1 special character (!@#\$%^&*)", hasSpecialChar),
                      const SizedBox(height: 30),
                      // --- Signup Button ---
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(70, 34, 85, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              onPressed: _signup, // Calls signup function
                              child: const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                
                      const SizedBox(height: 20),
                      // --- Navigate to Login ---
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                          ),
                          child: const Text(
                            "Already have an account? Log in",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}