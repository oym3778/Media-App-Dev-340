import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'equipment.dart';

import 'ExerciseProvider.dart';

void main() {
  runApp(const LoadExercisesPage());
}

class LoadExercisesPage extends StatelessWidget {
  const LoadExercisesPage({super.key});

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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchExcController = TextEditingController();

  // api vairables:
  // List<Exercise> data = []; PROVIUDER DOESNT USE THIS

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Tali Fitness"),
      //   backgroundColor: Colors.teal,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: searchExcController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length <= 2) {
                      return "Please Enter A Valid Search";
                    }
                    searchTerm = value;
                    return null;
                  },
                  // focusNode: _searchTerm,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3.0,
                          color: Colors.black), // Default border thickness
                    ),
                    label: Text("Search Term"),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          searchExcController.clear();
                        });
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: dropDownButton(
                      'Category',
                      categoryList,
                      selectedCategory,
                    ),
                  ),
                  Expanded(
                    child: dropDownButton(
                      'Equipment',
                      equipmentList,
                      selectedEquipment,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // since some images are null we can sort the list to keep images and null images seperate,
                  // looks cleaner i think
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  // TODO have a reset function for all filters
                  categoryList = [
                    DropdownMenuItem(
                      value: "N/A",
                      child: Text("N/A"),
                    ),
                  ];
                  // var dataResponse = await getData(searchTerm);

                  // setState(() {
                  //   data = dataResponse;
                  //   data.sort((a, b) => b.imageURL!.compareTo(a.imageURL!));
                  // });
                  await context.read<ExerciseProvider>().getData(searchTerm);
                  context.read<ExerciseProvider>().getExerciseByIDs();
                }
              },
              style: ButtonStyle(
                padding:
                    WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
              ),
              child: const Text(
                'Search',
                selectionColor: Colors.black,
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 400,
              child: GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3.5,
                    mainAxisSpacing: 7, // Adjust spacing as needed
                    crossAxisSpacing: 10,
                  ),
                  itemCount: context.watch<ExerciseProvider>().items.length,
                  itemBuilder: (context, index) {
                    final exercise = context.watch<ExerciseProvider>().items[index];
                    return Container(
                      color: Colors.green,
                      child: Row(
                        children: [
                          context
                                      .watch<ExerciseProvider>()
                                      .items[index]
                                      .imageURL! !=
                                  "https://placehold.co/300x300/png"
                              ? SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Image.network(context
                                      .watch<ExerciseProvider>()
                                      .items[index]
                                      .imageURL!),
                                )
                              : Container(),
                          Expanded(
                            child: Container(
                              color: Colors.blue,
                              height: double.infinity,
                              child: Expanded(
                                child: SingleChildScrollView(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                            "Name: ${context.watch<ExerciseProvider>().items[index].name}"),
                                        Text(
                                            "Category ${context.watch<ExerciseProvider>().items[index].category}"),
                                        Text(
                                            "ID: ${context.watch<ExerciseProvider>().items[index].id}"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            height: double.infinity,
                            width: 50,
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeIn,
                            child: Material(
                              color: Colors.yellow,
                              child: InkWell(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "ADD",
                                    )),
                                onTap: () {
                                  setState(() {
                                    context.read<ExerciseProvider>().addWorkout(exercise);
                                    //TODO remove the workout from the items array in the future provider so you can add workouts twice
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Container dropDownButton(String name, var options, String? currentValue) {
    return Container(
      color: Colors.white,
      height: 70,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: name,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ), // Default border thickness
          ),
        ),
        items: options,
        value: currentValue,
        onChanged: (selected) {
          setState(() {
            if (name == "Category") {
              selectedCategory = selected!;
            } else if (name == "Equipment") {
              selectedEquipment = selected!;
            }
            currentValue =
                selected; // i think this is an issue of pass by value vs reference. String is being passed by value i believe
          });

          context
              .read<ExerciseProvider>()
              .filter(selectedCategory, selectedEquipment);
        },
      ),
    );
  }
}
