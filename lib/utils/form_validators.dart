class FormValidators {

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter student name';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name should only contain letters';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter age';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Enter a valid number';
    }
    
    if (age < 3) {
      return 'Student must be at least 3 years old';
    }
    
    if (age > 20) {
      return 'Student age cannot exceed 20 years';
    }
    
    return null;
  }


  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email address';
    }
    

final emailRegex = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"
);

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    
    return null;
  }

  static String? validateParentName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter parent/guardian name';
    }
    
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z\s.]+$').hasMatch(value)) {
      return 'Name should only contain letters';
    }
    
    return null;
  }


  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter phone number';
    }
    
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit number';
    }
    
    return null;
  }
}