import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice/authentication/login_page.dart';
import 'package:practice/components/my_drawer.dart';
import 'package:practice/components/my_usertile.dart';
import 'package:practice/pages/chat_page.dart';
import 'package:practice/services/chat/chat_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatServices _chatServices = ChatServices();
  

  get snapshot => null;
// get user

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VibeMatch'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),

      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  //build a list of users excluding current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatServices.getUserStream(),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return const Text('Error');
          }

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }

          // return listview
          return ListView(
            children: snapshot.data!.map<Widget>((UserData) => _buildUserListItem(UserData, context)).toList(),
          );
        });
  }
  //build individual list tile for user

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user

    if (userData["email"] != getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        receiverEmail: userData['email'],
                        receiverID: userData['uid'],
                      )));
        },
      );
    } else {
      return Container();
    }
  }
}
