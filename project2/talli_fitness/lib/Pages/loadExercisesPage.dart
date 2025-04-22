import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ExerciseProvider.dart';
import '../Filterables/equipment.dart';

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
  
  // used to validate the search result / clear searched input
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

        // The main portion of this page lies within one column
        child: Column(
          children: [
            Form(
              key: _formKey,
              // The inital search bar for exercises
              child: TextFormField(
                onChanged: (value) {
                  // TODO THIS is where well need to add some update logic to always 
                  // perform a search when the user types in the search bar
                },
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
            // This row is dedicated to showing or hideing the filter options
            Row(
              children: [
                // Since the user hasn't searched anything, they shouldnt be able to filter their search, hide the 
                // Category filter for now until they actually search for something
                // since the categoryList only has 1 DropdownMenuItem which is (N/A) if there is more than 1 we know its been populated with 
                // a filterable option
                if (context.watch<ExerciseProvider>().categoryList.length > 1)
                  Expanded(
                    child: dropDownButton(
                      'Category',
                      context.watch<ExerciseProvider>().categoryList,
                      context.watch<ExerciseProvider>().selectedCategory,
                    ),
                  ),
                
                // Same thing as above but this one is in charge of hideing the equpment filter
                // TODO This filter needs to be correctly implemented, as of now its slow and inefficiently querired
                if (context.watch<ExerciseProvider>().equipmentList.length > 1)
                  Expanded(
                    child: dropDownButton(
                      'Equipment',
                      context.watch<ExerciseProvider>().equipmentList,
                      context.watch<ExerciseProvider>().selectedEquipment,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16), // SPACE BETWEEN FILTER AND SEARCH BUTTON
            // The search button, when clicked will use the provider to fill the GridView.builder below
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Everytime we search, we need to reset out selected Category AND Equipment, otherwise you may end up in a situation
                  // Where, the user has search for squats and filters based on Legs
                  // Then they search for Push-ups which will show options that have no filterable Legs category
                  // This would crash the app, therefore everytime you hit search we reset your selected category and equipent to N/A
                  context
                      .read<ExerciseProvider>()
                      .updateSelectedCategory("N/A");
                  context
                      .read<ExerciseProvider>()
                      .updateSelectedEquipment("N/A");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Searching...')),
                  );
                  // Fills in our data
                  await context.read<ExerciseProvider>().getData(searchTerm);
                  // ignore: use_build_context_synchronously
                  // context.read<ExerciseProvider>().getExerciseByIDs(); TODO need to correcty query for equipment
                }
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16), // SPACE BETWEEN SEARCH BAR AND EXERCISES
            SizedBox(
              height: 350,
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
                    itemCount: provider.searchedExercises.length,
                    itemBuilder: (context, index) {
                      // We are building a row for each exercise that appeared when the user searched
                      final exercise = provider.searchedExercises[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.teal.shade100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // exercises are initialzied with "no_image" if the image url ended in null
                            // so, if that happened, just dont show the image aka SizedBox
                            if (exercise.imageURL != null &&
                                exercise.imageURL !=
                                    "no_image")
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
                            // TODO show some sort of click effect when clicking add
                            // This is the add button
                            InkWell(
                              onTap: () {
                                setState(() {
                                  provider.addWorkout(exercise);
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

  
  /// This function is used to create the 2 filters you see, category or equipment
  Widget dropDownButton(String name, var options, String? currentValue) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: name),
      items: options,
      value: currentValue,
      onChanged: (selected) {
        setState(() {
          // updating either category or equipment will automatically filter based on that
          if (name == "Category") {
            context.read<ExerciseProvider>().updateSelectedCategory(selected!);
          } else if (name == "Equipment") {
            context.read<ExerciseProvider>().updateSelectedEquipment(selected!);
          }
        });
      },
    );
  }
}