import 'package:flutter/material.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("Tali Fitness"),
        centerTitle: true,
          backgroundColor: Colors.teal.shade700,
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Routine Page",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}