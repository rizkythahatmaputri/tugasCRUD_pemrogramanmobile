import 'package:tugas_crud/side_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({superKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: const SideMenu(),
      body: const Center(child: Text('selamat datang')),
    );
  }
}
