class ValidationResult {
  final String? error;
  const ValidationResult.ok() : error = null;
  const ValidationResult.fail(this.error);
  bool get isValid => error == null;
}

class AppValidation {
  static ValidationResult required(String value, String field) => value.trim().isEmpty
      ? ValidationResult.fail('$field: مهرباني وکړئ دا برخه ډکه کړئ.')
      : const ValidationResult.ok();

  static ValidationResult email(String value) {
    if (value.trim().isEmpty) return const ValidationResult.fail('برېښنالیک: دا برخه اړینه ده.');
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
    return ok ? const ValidationResult.ok() : const ValidationResult.fail('برېښنالیک: د ایمیل بڼه ناسمه ده.');
  }

  static ValidationResult password(String value) => value.length < 6
      ? const ValidationResult.fail('پټ نوم: لږ تر لږه ۶ کرکټرونه ولیکئ.')
      : const ValidationResult.ok();

  static ValidationResult positiveNumber(String value, String field) {
    final n = double.tryParse(value.trim());
    return n == null || n <= 0
        ? ValidationResult.fail('$field: له صفر څخه لویه شمېره ولیکئ.')
        : const ValidationResult.ok();
  }

  static ValidationResult nonNegativeInt(String value, String field) {
    final n = int.tryParse(value.trim());
    return n == null || n < 0
        ? ValidationResult.fail('$field: صفر یا مثبته شمېره ولیکئ.')
        : const ValidationResult.ok();
  }
}
