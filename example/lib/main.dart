import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haishin_kit_example/playback_page.dart';
import 'package:haishin_kit_example/preference_page.dart';

import 'ingest_page.dart';

void main() {
  runApp(const HaishinKitExampleApp());
}

class HaishinKitExampleApp extends StatelessWidget {
  const HaishinKitExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HaishinKitExample());
  }
}

class HaishinKitExample extends StatefulWidget {
  const HaishinKitExample({super.key});

  @override
  State<HaishinKitExample> createState() => _HaishinKitExampleState();
}

class _HaishinKitExampleState extends State<HaishinKitExample> {
  int _selectedIndex = 0;

  final _childPageList = [IngestPage(), PlaybackPage(), PreferencePage()];

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _childPageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'GO LIVE'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Playback'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'Preference'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _initPlatformState() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
