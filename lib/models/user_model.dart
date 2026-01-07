class User {
  User({
    required this.name,
    required this.age,
    required this.dob,
    required this.docId,
  });

  String age;

  String name;

  String dob;

  String docId;

  factory User.fromJson(String id, Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
      dob: json['dob'],
      docId: id,
    );
  }
}