// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import 'schedule_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _from;
  String? _to;
  DateTime? _travelDate;
  final List<String> _locations = ['Colombo', 'Kandy', 'Galle', 'Jaffna', 'Anuradhapura'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _travelDate) {
      setState(() {
        _travelDate = picked;
      });
    }
  }

  String _getText(String key, String lang) {
    Map<String, Map<String, String>> texts = {
      'English': {
        'from': 'From',
        'to': 'To',
        'travelDate': 'Travel Date',
        'selectDate': 'Select Date',
        'search': 'Search',
      },
      'Sinhala': {
        'from': 'සිට',
        'to': 'වෙත',
        'travelDate': 'ගමන් දිනය',
        'selectDate': 'දිනය තෝරන්න',
        'search': 'සෙවීම',
      },
      'Tamil': {
        'from': 'இருந்து',
        'to': 'க்கு',
        'travelDate': 'பயண தேதி',
        'selectDate': 'தேதியை தேர்வு செய்',
        'search': 'தேடு',
      },
    };
    return texts[lang]?[key] ?? texts['English']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      appBar: AppBar(
        title: Text(_getText('search', lang)),
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
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: _getText('from', lang),
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 18),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 16),
                value: _from,
                items: _locations.map((location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _from = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: _getText('to', lang),
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 18),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 16),
                value: _to,
                items: _locations.map((location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _to = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: _getText('travelDate', lang),
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 18),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  child: Text(
                    _travelDate == null ? _getText('selectDate', lang) : DateFormat('yyyy-MM-dd').format(_travelDate!),
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: Text(_getText('search', lang), style: const TextStyle(fontSize: 18)),
                onPressed: () {
                  if (_from != null && _to != null && _travelDate != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleScreen(
                          from: _from!,
                          to: _to!,
                          date: _travelDate!,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 10,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}