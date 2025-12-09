enum Flavor { dev, prod }

class AppConfig {
  final Flavor flavor;
  final String appName;
  final String baseUrl;

  static AppConfig? _instance;

  factory AppConfig({
    required Flavor flavor,
    required String appName,
    required String baseUrl,
  }) {
    _instance ??= AppConfig._internal(
      flavor: flavor,
      appName: appName,
      baseUrl: baseUrl,
    );
    return _instance!;
  }

  AppConfig._internal({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
  });

  static AppConfig get instance => _instance!;

  static bool get isDev => _instance?.flavor == Flavor.dev;
  static bool get isProd => _instance?.flavor == Flavor.prod;
}
