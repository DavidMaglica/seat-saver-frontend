extension StringCaseExtensions on String {
  String toTitleCase() => toLowerCase()
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');

  String toFormattedUpperCase() => toUpperCase().replaceAll('_', ' ');
}
