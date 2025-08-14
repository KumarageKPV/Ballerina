import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.greenAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search by route, origin, destination...',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Mock search action, navigate to schedule or booking
                Navigator.pushNamed(context, '/schedule');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                shadowColor: Colors.greenAccent,
                elevation: 10,
              ),
              child: const Text('Search', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Results will show schedules, fares, etc.',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            // ListView for results placeholder
          ],
        ),
      ),
    );
  }
}