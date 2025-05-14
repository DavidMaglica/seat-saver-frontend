extension StringCaseExtensions on String {
  String toTitleCase() => toLowerCase()
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');

  String toFormattedUpperCase() => toUpperCase().replaceAll('_', ' ');
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? false);

  bool get isNotNullAndNotEmpty => this != null && (this?.isNotEmpty ?? false);
}
