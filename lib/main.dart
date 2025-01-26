import 'package:flutter/material.dart';
import 'package:pressor/components/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pressor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: Colors.white,
            primary: Color(0xFF5BCEFA),
            secondary: Color(0xFFF5A9B8),
            surface: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget page = const Center(
    child: Text('Welcome to Pressor'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavBar(
        setPage: (page) => {
          setState(() {
            this.page = page;
          })
        },
      ),
    );
  }
}
