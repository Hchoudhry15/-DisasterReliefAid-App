import 'dart:html';

import 'package:flutter/material.dart';

class UserSelectionView extends StatefulWidget {
  const UserSelectionView({super.key});

  @override
  State<UserSelectionView> createState() => _UserSelectionViewState();
}

class _UserSelectionViewState extends State<UserSelectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text("Choose User Type"),
    ));
  }
}
