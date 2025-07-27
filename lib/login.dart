import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication package

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers to capture username and password text field inputs
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Controls password visibility toggle
  bool _obscurePassword = true;

  // Function to handle login logic using Firebase Authentication
  Future<void> _login() async {
    final email =
        _usernameController.text.trim(); // Get email input and trim spaces
    final password =
        _passwordController.text.trim(); // Get password input and trim spaces

    // If either field is empty, show a snackbar and return early
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    try {
      // Firebase sign-in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to Home page if login is successful
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // Show Firebase error message if login fails
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White page background
      // --- AppBar ---
      appBar: AppBar(
        elevation: 0, // Removes shadow
        backgroundColor: const Color.fromRGBO(
          192,
          204,
          218,
          1,
        ), // Light blue-grey header
        centerTitle: true, // Centers "KENKO"
        title: Text(
          "KENKO",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: const Color.fromRGBO(
              66,
              76,
              90,
              1,
            ), // Deep greyish text color
          ),
        ),
      ),

      // --- Body content ---
      body: SafeArea(
        child: SingleChildScrollView(
          // Enables scrolling to avoid overflow on small screens
          child: Column(
            children: [
              const SizedBox(height: 50), // Top spacing

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ), // Side padding
                child: Column(
                  children: [
                    // --- Username TextField ---
                    TextField(
                      controller:
                          _usernameController, // Binds input to controller
                      decoration: const InputDecoration(
                        hintText: "Username", // Placeholder text
                        border: InputBorder.none, // Removes default underline
                      ),
                    ),
                    const Divider(thickness: 1), // Divider line under textfield

                    const SizedBox(height: 20),

                    // --- Password TextField ---
                    TextField(
                      controller: _passwordController,
                      obscureText:
                          _obscurePassword, // Controls password visibility
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons
                                    .visibility_off // Eye with slash (hidden)
                                : Icons.visibility, // Eye open (visible)
                          ),
                          onPressed: () {
                            // Toggle password visibility state
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const Divider(thickness: 1),

                    const SizedBox(height: 40),

                    // --- Login Button ---
                    SizedBox(
                      width: double.infinity, // Full-width button
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            66,
                            76,
                            90,
                            1,
                          ), // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // Rounded edges
                          ),
                        ),
                        onPressed: _login, // Calls the login handler
                        child: const Text(
                          "LOG IN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.white, // White text
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Signup link ---
                    GestureDetector(
                      onTap: () {
                        // Redirects to signup page
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: const Text(
                        "Not registered yet? Register", // Signup text link
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
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
