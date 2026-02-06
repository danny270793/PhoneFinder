abstract class LocaleRepository {
  Future<void> saveLocale({required String languageCode});

  String? getLocale();

  Future<void> clearLocale();
}
