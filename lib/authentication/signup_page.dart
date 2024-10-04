import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:practice/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  signUp() async {
    // Ensure all fields are filled
    if (_emailcontroller.text.isEmpty || _passwordcontroller.text.isEmpty || _username.text.isEmpty) {
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
      // Create user with Firebase
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailcontroller.text,
        password: _passwordcontroller.text,
      );

      // Store User into a seperate doc

      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid':userCredential.user!.uid,
        'username':_username.text
      });


      // Navigate to AuthService page after successful sign-up
      Get.offAll(const AuthService());
    } catch (e) {
      // Display Snackbar on error
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.red, // Customize the error message color
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Center(
            child: Text(
          'VibeMatch',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 60,
                ),
                const SizedBox(
                  height: 20,
                ),

                const Text(
                  'Create Your Vibe Account',
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(
                  height: 20,
                ),

                //Username

                SizedBox(
                  width: screenWidth * 0.86,
                  height: 50,
                  child: TextField(
                    decoration: const InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)), fillColor: Color.fromARGB(255, 251, 219, 113), filled: true, hintText: 'Username', hintStyle: TextStyle(color: Colors.black)),
                    controller: _username,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                //Email Text field

                SizedBox(
                  width: screenWidth * 0.86,
                  height: 50,
                  child: TextField(
                    decoration: const InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)), fillColor: Color.fromARGB(255, 251, 219, 113), filled: true, hintText: 'Email', hintStyle: TextStyle(color: Colors.black)),
                    controller: _emailcontroller,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Password textfield

                SizedBox(
                  width: screenWidth * 0.86,
                  height: 50,
                  child: TextField(
                    decoration: const InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)), fillColor: Color.fromARGB(255, 251, 219, 113), filled: true, hintText: 'Password', hintStyle: TextStyle(color: Colors.black)),
                    controller: _passwordcontroller,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(fixedSize: Size(screenWidth * 0.86, 50), backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                    child: const Text(
                      'SignUp',
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
                const Text(
                  'SignUp',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
