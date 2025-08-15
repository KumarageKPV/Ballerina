// lib/screens/schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class ScheduleScreen extends StatelessWidget {
  final String? from;
  final String? to;
  final DateTime? date;

  const ScheduleScreen({
    super.key,
    this.from,
    this.to,
    this.date,
  });

  String _getText(String key, String lang) {
    Map<String, Map<String, String>> texts = {
      'English': {
        'schedules': 'Schedules',
        'duration': 'Duration',
        'busType': 'Bus Type',
        'model': 'Model',
        'busId': 'Bus Schedule ID',
        'bookSeat': 'Book Seat',
      },
      'Sinhala': {
        'schedules': 'කාලසටහන්',
        'duration': 'කාලය',
        'busType': 'බස් වර්ගය',
        'model': 'මොඩලය',
        'busId': 'බස් කාලසටහන් ID',
        'bookSeat': 'ආසනය වෙන්කරන්න',
      },
      'Tamil': {
        'schedules': 'அட்டவணைகள்',
        'duration': 'காலம்',
        'busType': 'பஸ் வகை',
        'model': 'மாடல்',
        'busId': 'பஸ் அட்டவணை ID',
        'bookSeat': 'இருக்கை பதிவு',
      },
    };
    return texts[lang]?[key] ?? texts['English']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final String formattedDate = date != null ? DateFormat('yyyy-MM-dd').format(date!) : 'Any Date';
    final String routeInfo = (from != null && to != null) ? 'from $from to $to on $formattedDate' : 'All Schedules';
    return Scaffold(
      appBar: AppBar(
        title: Text('${_getText('schedules', lang)} $routeInfo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: List.generate(3, (index) {
                return Card(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              height: 60,
                              child: Placeholder(), // Bus image
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Departure: $from $formattedDate 19:00'),
                                  Text('Arrival: $to ${date != null ? DateFormat('yyyy-MM-dd').format(date!.add(const Duration(days: 1))) : ''} 03:00'),
                                  Text('${_getText('duration', lang)}: 08:00 Hours'),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const Text('Rs. 1,269.00', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                                const Text('Available Seats: 21'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${_getText('busType', lang)}: Normal'),
                            Text('${_getText('model', lang)}: Ashok Leyland'),
                            Text('${_getText('busId', lang)}: KM38-1900-PK'),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/booking');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            child: Text(_getText('bookSeat', lang)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}