import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice/authentication/signup_page.dart';
import 'package:practice/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in
  Future<void> login() async {
    if (_emailcontroller.text.isEmpty || _passwordcontroller.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.red,
      );
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailcontroller.text,
        password: _passwordcontroller.text,
      );

      //save user info if it already doesnt exists

      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': _emailcontroller.text,
      });
      
      // Navigate to the HomePage after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      // Check for specific Firebase error codes
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'Invalid username or password.';
      }

      // Display the appropriate error message as a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Center(
            child: Text(
          'VibeMatch',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 60,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            // Email TextField
            SizedBox(
              width: screenWidth * 0.86,
              height: 50,
              child: TextField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  fillColor: Color.fromARGB(255, 251, 219, 113),
                  filled: true,
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                controller: _emailcontroller,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Password TextField
            SizedBox(
              width: screenWidth * 0.86,
              height: 50,
              child: TextField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  fillColor: Color.fromARGB(255, 251, 219, 113),
                  filled: true,
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                controller: _passwordcontroller,
                obscureText: true, // Hide password
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Login Button
            Center(
              child: ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(screenWidth * 0.86, 50),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Don\'t have an account? ',
              style: TextStyle(fontSize: 14),
            ),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const signUpPage(),
                ),
              ),
              child: const Text(
                'SignUp',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
