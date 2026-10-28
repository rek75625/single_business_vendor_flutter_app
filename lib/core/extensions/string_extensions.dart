extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty ? word : word.capitalize())
        .join(' ');
  }

  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool isValidPhone() {
    // Egyptian phone format: 01XXXXXXXXX (11 digits starting with 01)
    final phoneRegex = RegExp(r'^01[0-2,5]{1}[0-9]{8}$');
    return phoneRegex.hasMatch(this);
  }
}
