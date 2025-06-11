import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/views/customer/home_screen.dart';
// import 'package:frontend/views/customer/home_screen.dart';
// import 'package:frontend/views/provider/dashboard_screen.dart'; // Adjust path if needed

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, 
      ),
      home: const HomePage( ),
    );
  }
}
