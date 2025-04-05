import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ExerciseProvider.dart';

class WorkoutApp extends StatefulWidget {
  const WorkoutApp({super.key});

  @override
  State<WorkoutApp> createState() => _WorkoutAppState();
}

class _WorkoutAppState extends State<WorkoutApp> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);  // Don't forget this line

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Workout App"),
      // ),
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text("The added workout count: ${provider.addedWorkout.length}"),
            ),
          );
        },
      ),
    );
  }
}
