import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'equipment.dart';

List<int> equipment = [];

// api vairables:
String baseUrl = "https://wger.de/api/v2/exercise/search/?language=4&term=";
String searchTerm = "";
var equipmentList = [
  DropdownMenuItem(
    value: "N/A",
    child: Text("N/A"),
  ),
];
var categoryList = [
  DropdownMenuItem(
    value: "N/A",
    child: Text("N/A"),
  ),
];

String selectedCategory = "N/A";
String selectedEquipment = "N/A";

class Exercise {
  String? name;
  String? imageURL;
  String? id;
  String? category;
  var equipment = [];

  Exercise({
    required this.name,
    required this.imageURL,
    required this.id,
    required this.category,
    required this.equipment,
  }) {
    if (imageURL == "https://wger.de/null") {
      imageURL = "https://placehold.co/300x300/png";
      //https://wger.de/
    }
  }
}

class ExerciseProvider extends ChangeNotifier {
  List<Exercise> items = [];

  Future<void> getData(String searchTerm) async {
    var response = await http.get(Uri.parse("$baseUrl$searchTerm"));

    var categories = [];

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (int i = 0; i < data["suggestions"].length; i++) {
        items.add(
          Exercise(
              name: data["suggestions"][i]["data"]["name"].toString(),
              imageURL:
                  "https://wger.de/${data["suggestions"][i]["data"]["image"].toString()}",
              id: data["suggestions"][i]["data"]["base_id"].toString(),
              category: data["suggestions"][i]["data"]["category"].toString(),
              equipment: []),
        );

        // if category is already in the list, dont add. Otherwise add it.
        // Doing this so we can let the user only filter categories that were queried in above response.
        // Doing squats most likely wont work out our arms. So, Arms wont show up as filterable... unless it did show up in the list....
        if (!categories.contains(items[i].category)) {
          categories.add(items[i].category);
          categoryList.add(
            DropdownMenuItem(
              value: items[i].category,
              child: Text("${items[i].category}"),
            ),
          );
        }

        // do the same thing for equipment with a bit more work since we aren't given equipment in the inital request...
      }
    }
    items.sort((a, b) => b.imageURL!.compareTo(a.imageURL!));
    notifyListeners(); // let everyone know something changed
  }

  Future<void> getExerciseByIDs() async {
    List<int> allEquipment = []; // Temporary list to collect all equipment IDs

    for (int i = 0; i < items.length; i++) {
      var responseID = await http.get(
        Uri.parse("https://wger.de/api/v2/exercise/${items[i].id}"),
      );

      if (responseID.statusCode == 200) {
        var dataID = json.decode(responseID.body);
        allEquipment.addAll(
            List<int>.from(dataID["equipment"])); // Collect all equipment IDs
        items[i].equipment = dataID["equipment"];
      }
    }

    // Remove duplicates using a Set
    Set<int> uniqueEquipment = allEquipment.toSet();
    equipment = uniqueEquipment.toList(); // Convert back to List

    for (int i = 0; i < equipment.length; i++) {
      equipmentList.add(
        DropdownMenuItem(
          value: allPossibleExercises[i]["name"].toString(),
          child: Text(allPossibleExercises[i]["name"].toString()),
        ),
      );
    }

    notifyListeners(); // Notify UI of changes
  }

  void filter(String category, String equipments) {
    if (category == "N/A" && equipments == "N/A") {
      items.sort((a, b) => b.imageURL!.compareTo(a.imageURL!));
    } else if(category != "N/A") {
      items.sort((a, b) {
        // Prioritize items matching the given category
        if (a.category == category && b.category != category) {
          return -1; // a comes first
        } else if (b.category == category && a.category != category) {
          return 1; // b comes first
        }
        return 0; // Otherwise, keep order unchanged
      });
    }

    if(equipments != "N/A"){
      items.sort((a, b) {
        // Prioritize items matching the given category
        if (a.equipment.contains(equipments) && !b.equipment.contains(equipments)) {
          return -1; // a comes first
        } else if (!a.equipment.contains(equipments) && b.equipment.contains(equipments)) {
          return 1; // b comes first
        }
        return 0; // Otherwise, keep order unchanged
      });
    }



    // items.sort((a, b) => b.equipment!.compareTo(a.equipment!));
    notifyListeners();
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExerciseProvider>(
      create: (context) {
        return ExerciseProvider();
      },
      child: MaterialApp(
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
      appBar: AppBar(
        title: Text("Tali Fitness"),
        backgroundColor: Colors.teal,
      ),
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
                                  setState(() {});
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            )
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

          context.read<ExerciseProvider>().filter(selectedCategory, selectedEquipment);
        },
      ),
    );
  }
}
