import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_reserver/main.dart';

class MockSharedPreferences extends Mock
    implements SharedPreferencesWithCache {}

MockSharedPreferences setupSharedPrefsMock({
  Map<String, Object?>? initialValues,
}) {
  final mockPrefs = MockSharedPreferences();

  when(() => mockPrefs.getInt(any())).thenReturn(null);
  when(() => mockPrefs.getString(any())).thenReturn(null);
  when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
  when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);
  when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
  when(() => mockPrefs.clear()).thenAnswer((_) async => true);

  initialValues?.forEach((key, value) {
    if (value is int) {
      when(() => mockPrefs.getInt(key)).thenReturn(value);
    }
    if (value is String) {
      when(() => mockPrefs.getString(key)).thenReturn(value);
    }
  });

  sharedPreferencesCache = mockPrefs;
  return mockPrefs;
}
