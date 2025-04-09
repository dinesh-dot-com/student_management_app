import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';
import '../utils/form_validators.dart';

class StudentForm extends ConsumerStatefulWidget {
  final Student? student;

  const StudentForm({super.key, this.student});

  @override
  ConsumerState<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends ConsumerState<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController parentNameCtrl;
  late TextEditingController parentPhoneCtrl;

  String? _selectedGender;
  String? _selectedGrade;
  String? _selectedBloodGroup;
  bool _isValid = false;
  Timer? _debounce;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _grades = List.generate(12, (index) => '${index + 1}th Standard');
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.student?.name ?? '');
    ageCtrl = TextEditingController(text: widget.student?.age.toString() ?? '');
    emailCtrl = TextEditingController(text: widget.student?.email ?? '');
    parentNameCtrl = TextEditingController(text: widget.student?.parentName ?? '');
    parentPhoneCtrl = TextEditingController(text: widget.student?.parentPhone ?? '');

    _selectedGender = widget.student?.gender;
    _selectedGrade = widget.student?.grade;
    _selectedBloodGroup = widget.student?.bloodGroup;

    nameCtrl.addListener(_validateForm);
    ageCtrl.addListener(_validateForm);
    emailCtrl.addListener(_validateForm);
    parentNameCtrl.addListener(_validateForm);
    parentPhoneCtrl.addListener(_validateForm);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    emailCtrl.dispose();
    parentNameCtrl.dispose();
    parentPhoneCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _validateForm() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final isValid = _formKey.currentState?.validate() ?? false;
      setState(() {
        _isValid = isValid;
      });
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        id: widget.student?.id ?? _uuid.v4(),
        name: nameCtrl.text.trim(),
        age: int.parse(ageCtrl.text.trim()),
        email: emailCtrl.text.trim(),
        gender: _selectedGender!,
        grade: _selectedGrade!,
        bloodGroup: _selectedBloodGroup!, 
        parentName: parentNameCtrl.text.trim(),
        parentPhone: parentPhoneCtrl.text.trim(),
      );

      final notifier = ref.read(studentListProvider.notifier);
      widget.student != null ? notifier.updateStudent(student) : notifier.addStudent(student);

      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student ${widget.student != null ? 'updated' : 'added'} successfully!'),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.student != null;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Update Student' : 'Add Student',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () {
                _showDeleteConfirmation(context);
              },
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F5F5), Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5E35B1),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              isEdit ? Icons.edit_note_rounded : Icons.person_add_alt_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            isEdit ? 'Student Information' : 'New Student Registration',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Details',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            nameCtrl, 
                            'Full Name', 
                            Icons.person_rounded,
                            FormValidators.validateName,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: ageCtrl,
                                  decoration: InputDecoration(
                                    labelText: 'Age',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: const Icon(Icons.cake_rounded),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: FormValidators.validateAge,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown(
                                  'Gender', 
                                  _genders, 
                                  _selectedGender, 
                                  Icons.wc_rounded, 
                                  (val) {
                                    setState(() {
                                      _selectedGender = val;
                                      _validateForm();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            emailCtrl, 
                            'Email Address', 
                            Icons.email_rounded,
                            FormValidators.validateEmail,
                            type: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          Text(
                            'Academic Information',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  'Grade', 
                                  _grades, 
                                  _selectedGrade, 
                                  Icons.school_rounded, 
                                  (val) {
                                    setState(() {
                                      _selectedGrade = val;
                                      _validateForm();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown(
                                  'Blood Group', 
                                  _bloodGroups, 
                                  _selectedBloodGroup, 
                                  Icons.bloodtype_rounded, 
                                  (val) {
                                    setState(() {
                                      _selectedBloodGroup = val;
                                      _validateForm();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          Text(
                            'Parent/Guardian Information',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            parentNameCtrl, 
                            'Parent/Guardian Name', 
                            Icons.person_2_rounded,
                            FormValidators.validateParentName,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: parentPhoneCtrl,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.phone_rounded),
                              hintText: '10-digit number',
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            validator: FormValidators.validatePhone,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: _isValid ? _save : null,
                              icon: Icon(
                                isEdit ? Icons.update_rounded : Icons.save_rounded,
                                size: 22,
                              ),
                              label: Text(
                                isEdit ? 'UPDATE STUDENT' : 'SAVE STUDENT',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text('Delete Student?'),
          ],
        ),
        content: const Text('This action cannot be undone. Are you sure you want to remove this student?'),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('DELETE'),
            onPressed: () {
              if (widget.student != null) {
                ref.read(studentListProvider.notifier).deleteStudent(widget.student!.id);
                Navigator.pop(context); 
                Navigator.pop(context); 
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon,
    String? Function(String?)? validator,
    {TextInputType type = TextInputType.text}
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      keyboardType: type,
      validator: validator,
    );
  }

  Widget _buildDropdown(
    String label, 
    List<String> items, 
    String? selectedValue, 
    IconData icon,
    void Function(String?)? onChanged
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Please select $label' : null,
      icon: const Icon(Icons.arrow_drop_down_circle_outlined),
      isExpanded: true,
      borderRadius: BorderRadius.circular(16),
      dropdownColor: Colors.white,
    );
  }
}