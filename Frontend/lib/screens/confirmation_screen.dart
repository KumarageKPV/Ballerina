// lib/screens/confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  String _getText(String key, String lang) {
    Map<String, Map<String, String>> texts = {
      'English': {
        'confirmed': 'Booking Confirmed!',
        'scan': 'Scan this QR at the bus',
      },
      'Sinhala': {
        'confirmed': 'වෙන්කිරීම තහවුරුයි!',
        'scan': 'බස් එකේ මෙම QR ස්කෑන් කරන්න',
      },
      'Tamil': {
        'confirmed': 'பதிவு உறுதிப்படுத்தப்பட்டது!',
        'scan': 'பஸ்ஸில் இந்த QR ஐ ஸ்கேன் செய்',
      },
    };
    return texts[lang]?[key] ?? texts['English']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      appBar: AppBar(title: Text(_getText('confirmed', lang))),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).scaffoldBackgroundColor, Theme.of(context).primaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getText('confirmed', lang),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Theme.of(context).primaryColor, blurRadius: 10)],
                ),
                child: const Center(child: Text('QR Code Placeholder')),
              ),
              const SizedBox(height: 20),
              Text(
                _getText('scan', lang),
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}