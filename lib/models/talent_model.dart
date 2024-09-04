class TalentModel {
  String name;
  int age;
  double height;
  double weight;
  List<String> interests;
  List<String> skills;
  List<String> careerItems;
  List<String> photoUrls;

  TalentModel({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.interests,
    required this.skills,
    required this.careerItems,
    required this.photoUrls,
  });

  // Convert a TalentModel into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'interests': interests.join(','),
      'skills': skills.join(','),
      'careerItems': careerItems.join('|'),
      'photoUrls': photoUrls.join('|'),
    };
  }

  // Create a TalentModel from a Map
  factory TalentModel.fromMap(Map<String, dynamic> map) {
    return TalentModel(
      name: map['name'],
      age: map['age'],
      height: map['height'],
      weight: map['weight'],
      interests: map['interests'].split(','),
      skills: map['skills'].split(','),
      careerItems: map['careerItems'].split('|'),
      photoUrls: map['photoUrls'].split('|'),
    );
  }
}
