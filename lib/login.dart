import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; //Firebase authentication package

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
    final email = _usernameController.text.trim(); // Get email input and trim spaces
    final password = _passwordController.text.trim(); // Get password input and trim spaces

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(99, 75, 102, 1), 
      // --- Body content ---
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
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 28, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const Text("Log in to continue"),
                      const SizedBox(height: 20),
                      // --- Username TextField ---
                      TextField(
                        controller: _usernameController, // Binds input to controller
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          hintText: "Username", // Placeholder text
                          hintStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey), // Line under textfield
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // --- Password TextField ---
                      TextField(
                        controller: _passwordController, 
                        
                        textAlign: TextAlign.left,
                        obscureText: _obscurePassword, // Controls password visibility
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off // Eye with slash (hidden)
                                  : Icons.visibility, // Eye open (visible)
                              color: Colors.grey,
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
                      
                      const SizedBox(height: 40),

                      // --- Login Button ---
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: double.infinity, // Full-width button
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(70, 34, 85, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0), // Rounded edges
                              ),
                            ),
                            onPressed: _login, // Calls the login handler
                            child: const Text(
                              "LOG IN",
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
                      // --- Signup link ---
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Redirects to signup page
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: const Text(
                            "Not registered yet? Register", // Signup text link
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