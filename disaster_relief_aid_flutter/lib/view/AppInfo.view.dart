import 'package:flutter/material.dart';

class AppInfoView extends StatefulWidget {
  const AppInfoView({super.key});

  @override
  State<AppInfoView> createState() => _AppInfoViewState();
}

class _AppInfoViewState extends State<AppInfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Information'),
      ),
      body: const Center(
        child: Text('App Information'),
      ),
    );
  }
}
