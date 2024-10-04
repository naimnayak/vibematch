import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice/pages/settings_page.dart';
import 'package:practice/authentication/login_page.dart'; 

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    // After logout, navigate to login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Colors.grey[500],
                    size: 64,
                  ),
                ),
              ),
              // Home List Tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    'Home',
                    style: TextStyle(color: Colors.grey[900]),
                  ),
                  leading: Icon(
                    Icons.home,
                    color: Colors.grey[500],
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // Settings List Tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    'Settings',
                    style: TextStyle(color: Colors.grey[900]),
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: Colors.grey[500],
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    // Navigate to settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                ),
              ),
            ],
          ),
          // Logout List Tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.grey[900]),
              ),
              leading: Icon(
                Icons.logout,
                color: Colors.grey[500],
                size: 30,
              ),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
