class ProfileData {
  String name;
  String nameJapanese;
  String birthDate;
  String birthPlace;
  String height;
  String weight;
  String bust;
  String waist;
  String hip;
  String shoeSize;
  String hobby;
  String skill;
  String qualification;
  String education;
  String catchphrase;
  String followers;
  String twitterAccount;
  String tiktokAccount;
  String instagramAccount;
  String managerName;
  String managerEmail;
  String managerPhone;
  String agency;
  List<Map<String, List<String>>> careerList;
  List<String> photosPaths;

  ProfileData({
    this.name = '',
    this.nameJapanese = '',
    this.birthDate = '',
    this.birthPlace = '',
    this.height = '',
    this.weight = '',
    this.bust = '',
    this.waist = '',
    this.hip = '',
    this.shoeSize = '',
    this.hobby = '',
    this.skill = '',
    this.qualification = '',
    this.education = '',
    this.catchphrase = '',
    this.followers = '',
    this.twitterAccount = '',
    this.tiktokAccount = '',
    this.instagramAccount = '',
    this.managerName = '',
    this.managerEmail = '',
    this.managerPhone = '',
    this.agency = '',
    this.careerList = const [],
    this.photosPaths = const [],
  });

  // オプション: データをJSONに変換するメソッド
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameJapanese': nameJapanese,
      'birthDate': birthDate,
      'birthPlace': birthPlace,
      'height': height,
      'weight': weight,
      'bust': bust,
      'waist': waist,
      'hip': hip,
      'shoeSize': shoeSize,
      'hobby': hobby,
      'skill': skill,
      'qualification': qualification,
      'education': education,
      'catchphrase': catchphrase,
      'followers': followers,
      'twitterAccount': twitterAccount,
      'tiktokAccount': tiktokAccount,
      'instagramAccount': instagramAccount,
      'managerName': managerName,
      'managerEmail': managerEmail,
      'managerPhone': managerPhone,
      'agency': agency,
      'careerList': careerList,
      'photosPaths': photosPaths,
    };
  }

  // オプション: JSONからデータを生成するファクトリメソッド
  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: json['name'] ?? '',
      nameJapanese: json['nameJapanese'] ?? '',
      birthDate: json['birthDate'] ?? '',
      birthPlace: json['birthPlace'] ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      bust: json['bust'] ?? '',
      waist: json['waist'] ?? '',
      hip: json['hip'] ?? '',
      shoeSize: json['shoeSize'] ?? '',
      hobby: json['hobby'] ?? '',
      skill: json['skill'] ?? '',
      qualification: json['qualification'] ?? '',
      education: json['education'] ?? '',
      catchphrase: json['catchphrase'] ?? '',
      followers: json['followers'] ?? '',
      twitterAccount: json['twitterAccount'] ?? '',
      tiktokAccount: json['tiktokAccount'] ?? '',
      instagramAccount: json['instagramAccount'] ?? '',
      managerName: json['managerName'] ?? '',
      managerEmail: json['managerEmail'] ?? '',
      managerPhone: json['managerPhone'] ?? '',
      agency: json['agency'] ?? '',
      careerList: (json['careerList'] as List<dynamic>?)
              ?.map((e) => Map<String, List<String>>.from(e))
              .toList() ??
          [],
      photosPaths: List<String>.from(json['photosPaths'] ?? []),
    );
  }
}
