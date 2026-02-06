abstract class PreferencesRepository {
  Future<void> setString({required String key, required String value});
  String? getString({required String key});
  Future<void> remove({required String key});
  bool containsKey({required String key});
}
