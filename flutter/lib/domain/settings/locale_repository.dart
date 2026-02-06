abstract class LocaleRepository {
  Future<void> saveLocale({required String languageCode});

  Future<String?> getLocale();

  Future<void> clearLocale();
}
