// lib/screens/booking_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _travelDate;
  List<bool> _selectedSeats = List.generate(54, (_) => false);
  List<int> _bookedSeats = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]; // Mock booked seats

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
        'selectSeat': 'Select Seat',
        'travelDate': 'Travel Date',
        'selectDate': 'Select Date',
        'confirm': 'Confirm Booking',
      },
      'Sinhala': {
        'selectSeat': 'ආසනය තෝරන්න',
        'travelDate': 'ගමන් දිනය',
        'selectDate': 'දිනය තෝරන්න',
        'confirm': 'වෙන්කිරීම තහවුරු කරන්න',
      },
      'Tamil': {
        'selectSeat': 'இருக்கை தேர்வு',
        'travelDate': 'பயண தேதி',
        'selectDate': 'தேதியை தேர்வு செய்',
        'confirm': 'பதிவை உறுதிப்படுத்து',
      },
    };
    return texts[lang]?[key] ?? texts['English']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      appBar: AppBar(title: Text(_getText('selectSeat', lang))),
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
              Text(
                _getText('selectSeat', lang),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 54,
                  itemBuilder: (context, index) {
                    final seatNumber = index + 1;
                    final isBooked = _bookedSeats.contains(seatNumber);
                    final isSelected = _selectedSeats[index];
                    Color seatColor;
                    if (isBooked) {
                      seatColor = Colors.red;
                    } else if (isSelected) {
                      seatColor = Colors.green;
                    } else {
                      seatColor = Theme.of(context).textTheme.bodyLarge!.color!;
                    }
                    return GestureDetector(
                      onTap: isBooked
                          ? null
                          : () {
                        setState(() {
                          _selectedSeats[index] = !isSelected;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: seatColor,
                          border: Border.all(color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            seatNumber.toString().padLeft(2, '0'),
                            style: TextStyle(color: seatColor == Colors.green || seatColor == Colors.red ? Colors.white : Theme.of(context).scaffoldBackgroundColor),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: _getText('travelDate', lang),
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                  child: Text(
                    _travelDate == null ? _getText('selectDate', lang) : DateFormat('yyyy-MM-dd').format(_travelDate!),
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/confirmation');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 10,
                ),
                child: Text(_getText('confirm', lang), style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}