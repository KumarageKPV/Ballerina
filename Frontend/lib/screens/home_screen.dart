// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import 'search_screen.dart';
import 'dashboard_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Content', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    SearchScreen(),
    DashboardScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getLabel(String key, String lang) {
    Map<String, Map<String, String>> labels = {
      'English': {
        'home': 'Home',
        'search': 'Search',
        'dashboard': 'Dashboard',
        'settings': 'Settings',
      },
      'Sinhala': {
        'home': 'නිවස',
        'search': 'සෙවුම',
        'dashboard': 'ඩෑෂ්බෝඩ්',
        'settings': 'සැකසුම්',
      },
      'Tamil': {
        'home': 'வீடு',
        'search': 'தேடல்',
        'dashboard': 'டாஷ்போர்டு',
        'settings': 'அமைப்புகள்',
      },
    };
    return labels[lang]?[key] ?? labels['English']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      appBar: AppBar(
        title: Text(_getLabel('home', lang)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).scaffoldBackgroundColor, Theme.of(context).primaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: _getLabel('home', lang)),
          BottomNavigationBarItem(icon: const Icon(Icons.search), label: _getLabel('search', lang)),
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: _getLabel('dashboard', lang)),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: _getLabel('settings', lang)),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).textTheme.bodyMedium!.color,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onTap: _onItemTapped,
      ),
    );
  }
}