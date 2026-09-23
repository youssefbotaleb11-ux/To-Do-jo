import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String? userName;

  const HomeScreen({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Welcome, ${userName ?? "User"}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة احصائيات المهام زي الصورة اللي بعتها
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3F51B5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Column(
                    children: [
                      Text('12', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('Tasks', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('5', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('Done', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('7', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('Pending', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Today's Tasks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // أمثلة لمهام شكلية شبه التصميم
            Expanded(
              child: ListView(
                children: const [
                  Card(child: ListTile(title: Text('Flutter UI'), subtitle: Text('Build Register Screen'))),
                  Card(child: ListTile(title: Text('Workout'), subtitle: Text('Gym at 5 PM'))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}