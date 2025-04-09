import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';

class LocalStorageService {
  static const String _key = 'students_data';

  Future<void> saveStudents(List<Student> students) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = students.map((s) => s.toJson()).toList();
    prefs.setString(_key, jsonEncode(jsonList));
  }

  Future<List<Student>> loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) return [];

    final List decoded = jsonDecode(data);
    return decoded.map((json) => Student.fromJson(json)).toList();
  }
}