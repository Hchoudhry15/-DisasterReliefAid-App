import 'package:disaster_relief_aid_flutter/view/RequestHelp.view.dart';
import 'package:flutter/material.dart';

import 'Home.view.dart';
import 'Settings.view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  /// The index of the currently selected [BottomNavigationBarItem].
  int _selectedIndex = 0;

  /// Called when the user taps a button on the bottom navigation bar.
  /// The index of the button is passed as an argument.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DisasterReliefAid")),
      body: getCurrentPage(context, _selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}

Widget getCurrentPage(BuildContext context, int index) {
  switch (index) {
    case 0:
      return const HomeView();
    case 1:
      // TODO: Implement Hazard Map view
      return Container();
    case 2:
      return const SettingsView();
    default:
      return const HomeView();
  }
}
