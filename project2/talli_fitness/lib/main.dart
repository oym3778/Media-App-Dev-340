import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talli_fitness/Pages/registerPage.dart';
import 'package:talli_fitness/auth/login_or_register.dart';
import 'package:talli_fitness/firebase_options.dart';
import 'ExerciseProvider.dart';
import 'Pages/beginWorkoutPage.dart';
import 'Pages/loadExercisesPage.dart';
import 'Pages/addRoutinePage.dart';
import 'Pages/loginPage.dart';

/// V2 Requirments game plan Board
///
///
/// Firestore Authentication to create and keep accounts stored
/// Each account will have there own Weekly Routines

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
  RoutinePage(),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loggedIn ? bottomNavScreens[curButtonTab] : Container(),
      bottomNavigationBar: loggedIn
          ? BottomNavigationBar(
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.play_circle_fill),
                  label: "Add Routines",
                ),
              ],
              onTap: (value) {
                setState(() {
                  curButtonTab = value;
                });
              },
            )
          : LoginOrRegister()
    );
  }
}
