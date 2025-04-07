import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ExerciseProvider.dart';
import 'equipment.dart';

void main() {
  runApp(const LoadExercisesPage());
}

class LoadExercisesPage extends StatelessWidget {
  const LoadExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal.shade50,
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
          labelLarge: TextStyle(fontWeight: FontWeight.w600),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: TextStyle(color: Colors.teal),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontSize: 16),
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchExcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tali Fitness"),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: searchExcController,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length <= 2) {
                    return "Please enter a valid Exercise";
                  }
                  searchTerm = value;
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Enter An Exercise... ex squat",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () =>
                        setState(() => searchExcController.clear()),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (context.watch<ExerciseProvider>().categoryList.length > 1 ||
                    context
                            .watch<ExerciseProvider>()
                            .categoryList
                            .first
                            .value !=
                        "N/A")
                  Expanded(
                    child: dropDownButton(
                      'Category',
                      context.watch<ExerciseProvider>().categoryList,
                      context.watch<ExerciseProvider>().selectedCategory,
                    ),
                  ),
                if (context.watch<ExerciseProvider>().equipmentList.length >
                        1 ||
                    context
                            .watch<ExerciseProvider>()
                            .equipmentList
                            .first
                            .value !=
                        "N/A")
                  Expanded(
                    child: dropDownButton(
                      'Equipment',
                      context.watch<ExerciseProvider>().equipmentList,
                      context.watch<ExerciseProvider>().selectedEquipment,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  context
                      .read<ExerciseProvider>()
                      .updateSelectedCategory("N/A");
                  context
                      .read<ExerciseProvider>()
                      .updateSelectedEquipment("N/A");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Searching...')),
                  );
                  await context.read<ExerciseProvider>().getData(searchTerm);
                  // ignore: use_build_context_synchronously
                  // context.read<ExerciseProvider>().getExerciseByIDs();
                }
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: Consumer<ExerciseProvider>(
                builder: (context, provider, _) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 3.5,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: provider.items.length,
                    itemBuilder: (context, index) {
                      final exercise = provider.items[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.teal.shade100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            if (exercise.imageURL != null &&
                                exercise.imageURL !=
                                    "https://placehold.co/300x300/png")
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(exercise.imageURL!),
                                ),
                              ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Name: ${exercise.name}"),
                                      Text("Category: ${exercise.category}"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  context
                                      .read<ExerciseProvider>()
                                      .addWorkout(exercise);
                                });
                              },
                              child: Container(
                                height: double.infinity,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "ADD",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropDownButton(String name, var options, String? currentValue) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: name),
      items: options,
      value: currentValue,
      onChanged: (selected) {
        setState(() {
          if (name == "Category") {
            context.read<ExerciseProvider>().updateSelectedCategory(selected!);
          } else if (name == "Equipment") {
            context.read<ExerciseProvider>().updateSelectedEquipment(selected!);
          }
        });
        // context.read<ExerciseProvider>().filter(
        //     context.watch<ExerciseProvider>().selectedCategory,
        //     context.watch<ExerciseProvider>().selectedEquipment);
      },
    );
  }
}
