import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateEmail extends StatefulWidget {
  const UpdateEmail({super.key});

  @override
  State<UpdateEmail> createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {
  final _currentEmailController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _updateEmail() async {
    final currentEmail = _currentEmailController.text.trim();
    final newEmail = _newEmailController.text.trim();
    final confirmEmail = _confirmEmailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate inputs
    if (currentEmail.isEmpty || newEmail.isEmpty || confirmEmail.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    if (newEmail != confirmEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("New email and confirmation do not match.")),
      );
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email == currentEmail) {
        // Re-authenticate with the provided password
        AuthCredential credential = EmailAuthProvider.credential(
          email: currentEmail,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);

        // Update the email [THIS PART MAY BE BUGGY]
        await user.updateEmail(newEmail);

        // Success message without mentioning verification
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email updated successfully.")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Current email does not match.")),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Failed to update email.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(192, 204, 218, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "PROFILE",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Color.fromRGBO(66, 76, 90, 1),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentEmailController,
              decoration: const InputDecoration(labelText: 'Current Email Address'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newEmailController,
              decoration: const InputDecoration(labelText: 'New Email Address'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmEmailController,
              decoration: const InputDecoration(labelText: 'Confirm new Email Address'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Current Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateEmail,
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      ),
    );
  }
}