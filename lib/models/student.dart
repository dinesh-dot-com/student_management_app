class Student {
  final String id;
  final String name;
  final int age;
  final String email;
  final String gender;
  final String grade;
  final String bloodGroup;
  final String parentName;
  final String parentPhone;

  Student({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.gender,
    required this.grade,
    required this.bloodGroup,
    required this.parentName,
    required this.parentPhone,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        email: json['email'],
        gender: json['gender'],
        grade: json['grade'],
        bloodGroup: json['bloodGroup'],
        parentName: json['parentName'],
        parentPhone: json['parentPhone'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'email': email,
        'gender': gender,
        'grade': grade,
        'bloodGroup': bloodGroup,
        'parentName': parentName,
        'parentPhone': parentPhone,
      };
}
