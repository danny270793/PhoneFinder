/// Repository interface for locale storage operations
abstract class LocaleRepository {
  /// Save the selected locale language code (e.g., 'en', 'es')
  Future<void> saveLocale(String languageCode);

  /// Get the saved locale language code, returns null if not set
  String? getLocale();

  /// Clear the saved locale
  Future<void> clearLocale();
}
