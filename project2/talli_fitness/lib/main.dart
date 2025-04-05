import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ExerciseProvider.dart';
import 'beginWorkoutPage.dart';
import 'loadExercisesPage.dart';

// navigation variables
int curButtonTab = 0;
final bottomNavScreens = [
  LoadExercisesPage(),
  WorkoutApp(),
];

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ExerciseProvider(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
            fontFamily: "Regular",
            fontSize: 18,
          ),
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
      appBar: AppBar(
        title: Text("Tali Fitness"),
        backgroundColor: Colors.teal,
      ),
      body: bottomNavScreens[curButtonTab],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal,
        currentIndex: curButtonTab,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.first_page, color: Colors.white),
            label: "Load Exercises",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_moderator_outlined, color: Colors.white),
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
