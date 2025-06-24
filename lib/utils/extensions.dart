/// Extension on [String] providing convenient case formatting utilities.
extension StringCaseExtensions on String {
  /// Converts a string from snake_case or uppercase format to Title Case.
  ///
  /// Each word is capitalized and underscores are replaced with spaces.
  ///
  /// Example:
  /// ```dart
  /// 'my_enum_value'.toTitleCase(); // returns 'My Enum Value'
  /// 'ANOTHER_EXAMPLE'.toTitleCase(); // returns 'Another Example'
  /// ```
  String toTitleCase() => toLowerCase()
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');

  /// Converts a string to ALL UPPERCASE and replaces underscores with spaces.
  ///
  /// Useful for labels or enum display values.
  ///
  /// Example:
  /// ```dart
  /// 'my_enum_value'.toFormattedUpperCase(); // returns 'MY ENUM VALUE'
  /// ```
  String toFormattedUpperCase() => toUpperCase().replaceAll('_', ' ');
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? false);

  bool get isNotNullAndNotEmpty => this != null && (this?.isNotEmpty ?? false);
}
