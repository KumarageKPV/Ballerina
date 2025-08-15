// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _getText(String key, String lang) {
    Map<String, Map<String, String>> texts = {
      'English': {
        'upcoming': 'Upcoming Trips',
        'past': 'Past Trips',
        'status': 'Status',
        'date': 'Date',
        'route': 'Route',
        'qr': 'QR Code',
      },
      'Sinhala': {
        'upcoming': 'ඉදිරි ගමන්',
        'past': 'අතීත ගමන්',
        'status': 'තත්ත්වය',
        'date': 'දිනය',
        'route': 'මාර්ගය',
        'qr': 'QR කේතය',
      },
      'Tamil': {
        'upcoming': 'வரவிருக்கும் பயணங்கள்',
        'past': 'கடந்த பயணங்கள்',
        'status': 'நிலை',
        'date': 'தேதி',
        'route': 'வழி',
        'qr': 'QR கோட்',
      },
    };
    return texts[lang]?[key] ?? texts['English']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final currentDate = DateTime(2025, 8, 16);
    // Mock bookings
    final List<Map<String, dynamic>> bookings = [
      {'date': DateTime(2025, 8, 20), 'route': 'Colombo to Kandy', 'status': 'Confirmed'},
      {'date': DateTime(2025, 8, 10), 'route': 'Galle to Colombo', 'status': 'Completed'},
      {'date': DateTime(2025, 8, 25), 'route': 'Jaffna to Anuradhapura', 'status': 'Confirmed'},
      {'date': DateTime(2025, 7, 30), 'route': 'Kandy to Galle', 'status': 'Cancelled'},
    ];

    final upcoming = bookings.where((b) => b['date'].isAfter(currentDate)).toList();
    final past = bookings.where((b) => b['date'].isBefore(currentDate)).toList();

    return Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getText('upcoming', lang),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: upcoming.length,
                itemBuilder: (context, index) {
                  final trip = upcoming[index];
                  return Card(
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                    child: ListTile(
                      title: Text(trip['route'], style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color)),
                      subtitle: Text('${_getText('date', lang)}: ${DateFormat('yyyy-MM-dd').format(trip['date'])} | ${_getText('status', lang)}: ${trip['status']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.qr_code),
                        onPressed: () {
                          // Show QR code dialog or navigate
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(_getText('qr', lang)),
                              content: const SizedBox(
                                width: 200,
                                height: 200,
                                child: Center(child: Text('QR Code')),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _getText('past', lang),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: past.length,
                itemBuilder: (context, index) {
                  final trip = past[index];
                  return Card(
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                    child: ListTile(
                      title: Text(trip['route'], style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color)),
                      subtitle: Text('${_getText('date', lang)}: ${DateFormat('yyyy-MM-dd').format(trip['date'])} | ${_getText('status', lang)}: ${trip['status']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.qr_code),
                        onPressed: () {
                          // Show QR if applicable
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}