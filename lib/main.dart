import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:practice/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: 'AIzaSyD-Bo-9l2jqwpmuJeQMpGAR58jSntTpXXU',
          appId: '1:646296019057:android:e9f4b0bea49f77c983fbd0',
          messagingSenderId: '646296019057',
          projectId: 'practice0-cb571',
        ))
      : Firebase.initializeApp();
  Platform.isIOS
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: 'AIzaSyAaojhkNQ6C0Tudny7koum4c1ySS68hABQ',
          appId: '1:646296019057:ios:c7638fd380c7941c83fbd0',
          messagingSenderId: '646296019057',
          projectId: 'practice0-cb571',
        ))
      : Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthService(),
    );
  }
}
