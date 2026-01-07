class Students {
  final String docId;
  final String name;
  final String age;
  final String dob;

  Students({
    required this.docId,
    required this.name,
    required this.age,
    required this.dob,
  });

  factory Students.fromJson(String docId, Map<String, dynamic> json) {
    return Students(
      docId: docId,
      name: json['name'] ?? '',
      age: json['age'] ?? '',
      dob: json['dob'] ?? '',
    );
  }
}
