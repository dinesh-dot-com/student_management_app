import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../services/local_storage_service.dart';


final studentLoadingProvider = StateProvider<bool>((ref) => true);


final studentListProvider = StateNotifierProvider<StudentNotifier, List<Student>>((ref) {
  final notifier = StudentNotifier();

  notifier.loadStudents().then((_) {

    ref.read(studentLoadingProvider.notifier).state = false;
  });
  return notifier;
});

class StudentNotifier extends StateNotifier<List<Student>> {
  StudentNotifier() : super([]); 
  final _storage = LocalStorageService();
  
  Future<void> loadStudents() async {
    try {
      final students = await _storage.loadStudents();
      state = students;
    } catch (e) {
  
      state = [];
    }
  }
  
  void addStudent(Student student) {
    final updated = [...state, student];
    state = updated;
    _storage.saveStudents(updated);
  }
  
  void updateStudent(Student student) {
    final updated = state.map((s) => s.id == student.id ? student : s).toList();
    state = updated;
    _storage.saveStudents(updated);
  }
  
  void deleteStudent(String id) {
    final updated = state.where((s) => s.id != id).toList();
    state = updated;
    _storage.saveStudents(updated);
  }
}