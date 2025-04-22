import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ExerciseProvider.dart';
import 'beginWorkoutPage.dart';
import 'loadExercisesPage.dart';




/**
 * V2 Requirments game plan Board
 * 
 * 
 * Firestore Authentication to create and keep accounts stored
 * Each account will have there own Weekly Routines
 */

// ---------------------------------------------------------------------------------------------------------------------
//
// Note: The overall styling/coloring of this application were created with assistance from AI (ChatGPT by OpenAI).
//
// ---------------------------------------------------------------------------------------------------------------------

// Navigation variables
int curButtonTab = 0;
final bottomNavScreens = [
  LoadExercisesPage(),
  WorkoutApp(),
];

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ExerciseProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Regular',
        scaffoldBackgroundColor: Colors.grey.shade100,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.teal,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomNavScreens[curButtonTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: curButtonTab,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Load Exercises",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill),
            label: "Begin Workout",
          ),
        ],
        onTap: (value) {
          setState(() {
            curButtonTab = value;
          });
        },
      ),
    );
  }
}
