// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _getText(String key, String lang) {
    Map<String, Map<String, String>> texts = {
      'English': {
        'settings': 'Settings',
        'editProfile': 'Edit Profile',
        'changeLanguage': 'Change Language',
        'theme': 'Theme',
        'light': 'Light',
        'dark': 'Dark',
        'aboutUs': 'About Us',
        'signOut': 'Sign Out',
      },
      'Sinhala': {
        'settings': 'සැකසුම්',
        'editProfile': 'පැතිකඩ සංස්කරණය',
        'changeLanguage': 'භාෂාව වෙනස් කරන්න',
        'theme': 'තේමාව',
        'light': 'ආලෝකය',
        'dark': 'අඳුරු',
        'aboutUs': 'අප ගැන',
        'signOut': 'පිටවීම',
      },
      'Tamil': {
        'settings': 'அமைப்புகள்',
        'editProfile': 'சுயவிவரத்தை திருத்து',
        'changeLanguage': 'மொழியை மாற்று',
        'theme': 'தீம்',
        'light': 'ஒளி',
        'dark': 'இருள்',
        'aboutUs': 'எங்களைப் பற்றி',
        'signOut': 'வெளியேறு',
      },
    };
    return texts[lang]?[key] ?? texts['English']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final lang = languageProvider.language;
    return Scaffold(
      appBar: AppBar(
        title: Text(_getText('settings', lang)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).scaffoldBackgroundColor, Theme.of(context).primaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, size: 30),
                title: Text(_getText('editProfile', lang), style: const TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, size: 30),
                title: Text(_getText('changeLanguage', lang), style: const TextStyle(fontSize: 18)),
                trailing: DropdownButton<String>(
                  value: lang,
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyLarge!.color),
                  items: const ['English', 'Sinhala', 'Tamil'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      languageProvider.setLanguage(newValue);
                    }
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6, size: 30),
                title: Text(_getText('theme', lang), style: const TextStyle(fontSize: 18)),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeTrackColor: Colors.black,
                  activeColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                  inactiveThumbColor: Colors.white,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info, size: 30),
                title: Text(_getText('aboutUs', lang), style: const TextStyle(fontSize: 18)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      title: Text(_getText('aboutUs', lang), style: TextStyle(fontSize: 24, color: Theme.of(context).textTheme.bodyLarge!.color)),
                      content: Text(
                        'Bus Booking App - Your reliable partner for highway bus travels.',
                        style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium!.color),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close', style: TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, size: 30),
                title: Text(_getText('signOut', lang), style: const TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/onboarding');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}