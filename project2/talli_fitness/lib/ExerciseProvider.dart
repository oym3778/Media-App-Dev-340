import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'equipment.dart';

List<int> equipment = [];

// api vairables:
String baseUrl = "https://wger.de/api/v2/exercise/search/?language=2&term=";
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
  List<Exercise> addedWorkout = [];

  void addWorkout(Exercise exercise) {
    addedWorkout.add(exercise);
    notifyListeners();
  }

  void removeWorkout(Exercise exercise) {
    addedWorkout.remove(exercise);
    notifyListeners();
  }

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

    // TODO to fix filtering add the actual string name along with the int id it represents to
    // the equipment the current excerise has, this way we can refer to its id and string if needed for filtering

    // Remove duplicates using a Set
    Set<int> uniqueEquipment = allEquipment.toSet();
    equipment = uniqueEquipment.toList(); // Convert back to List

    for (int i = 0; i < equipment.length; i++) {
      equipmentList.add(
        DropdownMenuItem(
          value: allPossibleExercises[equipment[i] - 1]["name"].toString(),
          child:
              Text(allPossibleExercises[equipment[i] - 1]["name"].toString()),
        ),
      );
    }

    notifyListeners(); // Notify UI of changes
  }

  void filter(String category, String equipments) {
    if (category == "N/A" && equipments == "N/A") {
      items.sort((a, b) => b.imageURL!.compareTo(a.imageURL!));
    } else if (category != "N/A") {
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

    if (equipments != "N/A") {
      items.sort((a, b) {
        // Prioritize items matching the given category
        if (a.equipment.contains(equipments) &&
            !b.equipment.contains(equipments)) {
          return 1; // a comes first
        } else if (!a.equipment.contains(equipments) &&
            b.equipment.contains(equipments)) {
          return -1; // b comes first
        }
        return 0; // Otherwise, keep order unchanged
      });
    }

    // items.sort((a, b) => b.equipment!.compareTo(a.equipment!));
    notifyListeners();
  }
}
