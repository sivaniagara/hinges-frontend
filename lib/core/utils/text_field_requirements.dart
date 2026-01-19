

String? validateEmailId(String? value){
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }

  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }

  // optional: add complexity rules
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Include at least one uppercase letter';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Include at least one lowercase letter';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Include at least one number';
  }
  if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
    return 'Include at least one special character (!@#\$&*~)';
  }
  if(value.endsWith('@gmail.com')){
    return 'EmailId not valid';
  }

  return null; // valid
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }

  // Remove spaces and dashes
  value = value.replaceAll(RegExp(r'[\s\-]'), '');

  // Check if it's all digits
  if (!RegExp(r'^\d+$').hasMatch(value)) {
    return 'Phone number must contain only digits';
  }

  // Check length (India: 10 digits)
  if (value.length != 10) {
    return 'Phone number must be exactly 10 digits';
  }

  // Optional: Check starting digit (India mobile numbers start with 6-9)
  if (!RegExp(r'^[6-9]').hasMatch(value)) {
    return 'Phone number must start with digits 6-9';
  }

  return null; // valid
}
