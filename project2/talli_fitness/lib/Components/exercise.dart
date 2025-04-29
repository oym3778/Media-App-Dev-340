class Exercise {
  String? name;
  String? imageURL;
  String? id;
  String? category;

  int? rep;
  int? set;
  int? weight;

  var equipment = [];

  
  Exercise({
    required this.name,
    required this.imageURL,
    required this.id,
    required this.category,
    required this.equipment,
  }) {
    if (imageURL == "https://wger.de/null") {
      // imageURL = "https://placehold.co/300x300/png";
      imageURL = "no_image";
      //https://wger.de/
    }

    // default to 0 until the user creates a routine
    rep = 0;
    set = 0;
    weight = 0;
  }

  // Since Firestore doesn't understand custom object fields, well need to convert the excerise class into
  // Json to serialize it for firestore
  Map<String, dynamic> toJson(){
    return{
      'name': name,
      'imageURL': imageURL,
      'id': id,
      'category': category,
      'rep': rep,
      'set': set,
      'weight': weight,
      'equipment': equipment,
    };
  }
}
