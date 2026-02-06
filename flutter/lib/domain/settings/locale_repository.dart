abstract class LocaleRepository {
  Future<void> saveLocale(String languageCode);

  String? getLocale();

  Future<void> clearLocale();
}
