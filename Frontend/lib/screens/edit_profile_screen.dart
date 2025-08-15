// lib/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _getText(String key, String lang) {
    Map<String, Map<String, String>> texts = {
      'English': {
        'editProfile': 'Edit Profile',
        'name': 'Name',
        'email': 'Email',
        'phone': 'Phone',
        'save': 'Save',
        'updated': 'Profile Updated',
      },
      'Sinhala': {
        'editProfile': 'පැතිකඩ සංස්කරණය',
        'name': 'නම',
        'email': 'ඊමේල්',
        'phone': 'දුරකථන',
        'save': 'සුරකින්න',
        'updated': 'පැතිකඩ යාවත්කාලීන කරන ලදී',
      },
      'Tamil': {
        'editProfile': 'சுயவிவரத்தை திருத்து',
        'name': 'பெயர்',
        'email': 'மின்னஞ்சல்',
        'phone': 'தொலைபேசி',
        'save': 'சேமி',
        'updated': 'சுயவிவரம் புதுப்பிக்கப்பட்டது',
      },
    };
    return texts[lang]?[key] ?? texts['English']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      appBar: AppBar(
        title: Text(_getText('editProfile', lang)),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: _getText('name', lang),
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 18),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: _getText('email', lang),
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 18),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: _getText('phone', lang),
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 18),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_getText('updated', lang)),
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 10,
                  ),
                  child: Text(_getText('save', lang), style: const TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}