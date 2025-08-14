import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.cyanAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Bus Schedules',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 10, color: Colors.cyanAccent)],
              ),
            ),
            const SizedBox(height: 20),
            // Placeholder for list of schedules
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Mock data
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.cyanAccent),
                    ),
                    child: const ListTile(
                      title: Text('Route: City A to City B', style: TextStyle(color: Colors.white)),
                      subtitle: Text('Time: 10:00 AM | Fare: \$20', style: TextStyle(color: Colors.white70)),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/booking');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                shadowColor: Colors.cyanAccent,
                elevation: 10,
              ),
              child: const Text('Book Now', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}