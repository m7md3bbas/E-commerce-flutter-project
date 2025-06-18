import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _keyGender = 'gender';
  static const String _keyDateOfBirth = 'date_of_birth';

  Future<void> saveGender(
      {required String gender, required String gamil}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGender + gamil, gender);
  }

  Future<String?> getGender({required String gamil}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGender + gamil);
  }

  Future<void> saveDateOfBirth(
      {required String dateOfBirth, required String gamil}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDateOfBirth + gamil, dateOfBirth);
  }

  Future<String?> getDateOfBirth({required String gamil}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDateOfBirth + gamil);
  }

  Future<void> saveIsLoggedIn({required String token}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Token', token);
  }

  Future<String?> getIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('Token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('Token');
  }
}
