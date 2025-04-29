import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talli_fitness/Components/exercise.dart';
import 'package:talli_fitness/Components/exercise.dart';
import '../ExerciseProvider.dart';

class WorkoutApp extends StatefulWidget {
  const WorkoutApp({super.key});

  @override
  State<WorkoutApp> createState() => _WorkoutAppState();
}

class _WorkoutAppState extends State<WorkoutApp>
    with AutomaticKeepAliveClientMixin {
  // bool timerStarted = false;
  // int duration = 15;
  // late Timer _timer = Timer.periodic(Duration(seconds: 0), (timer) {});

  // void startTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (duration == 0) {
  //       setState(() => _timer.cancel());
  //     } else {
  //       setState(() => duration--);
  //     }
  //   });
  // }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    void startWorkoutSequence(List<Exercise> workouts) async {
      for (int i = 0; i < workouts.length; i++) {
        int countdown = 5;
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            Timer? timer;
            return StatefulBuilder(
              builder: (context, setState) {
                timer ??= Timer.periodic(Duration(seconds: 1), (_) {
                  if (countdown == 0) {
                    timer!.cancel();
                    Navigator.of(context).pop();
                  } else {
                    setState(() => countdown--);
                  }
                });

                return Dialog(
                  insetPadding: EdgeInsets.zero,
                  backgroundColor:
                      Colors.white.withOpacity(0.7), // translucent background
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (workouts[i].imageURL != null &&
                              workouts[i].imageURL !=
                                  "no_image")
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                workouts[i].imageURL!,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 24),
                          Text(
                            workouts[i].name ?? 'No name',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "$countdown",
                            style: const TextStyle(
                              fontSize: 48,
                              color: Colors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("🎉 Congratulations!"),
          content: const Text("You finished your workout!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              provider.addedExercises.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text(
                          "You have no workouts added...",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          height: 350,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 3.5,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: provider.addedExercises.length,
                            itemBuilder: (context, index) {
                              final exercise = provider.addedExercises[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    if (exercise.imageURL !=
                                        "no_image")
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                        ),
                                        child: Image.network(
                                          exercise.imageURL!,
                                          width: 120,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Name: ${exercise.name}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(height: 4),
                                              Text(
                                                  "Category: ${exercise.category}"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          provider.removeWorkout(exercise);
                                        });
                                      },
                                      child: Container(
                                        width: 60,
                                        decoration: const BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16),
                                            bottomRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.delete_forever,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                    final workouts = provider.addedExercises;
                    if (workouts.isNotEmpty) {
                      setState(() {});
                      startWorkoutSequence(workouts);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        "START",
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
