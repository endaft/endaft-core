import 'package:test/test.dart';
import 'package:endaft_core/common.dart';

void main() {
  group('Registry Tests', () {
    test('Verifies withConfig Singletons Work As Expected', () {
      final name = DateTime.now().millisecondsSinceEpoch.toString();
      final config = MockConfig({'name': name});
      final registry = MockRegistry();

      expect(() => registry.useConfig(config), returnsNormally);
      expect(() => registry.singleton, returnsNormally);
      expect(registry.singleton.name, equals(name));

      final single1 = registry.singleton;
      final single2 = registry.singleton;
      expect(single1, isNotNull);
      expect(single2, isNotNull);
      expect(single2, equals(single1));
    });

    test('Verifies withConfig Providers Work As Expected', () {
      final name = DateTime.now().millisecondsSinceEpoch.toString();
      final config = MockConfig({'name': name});
      final registry = MockRegistry();

      expect(() => registry.useConfig(config), returnsNormally);
      expect(() => registry.provider(), returnsNormally);

      final prov1 = registry.provider();
      final prov2 = registry.provider();
      expect(prov1, isNotNull);
      expect(prov2, isNotNull);
      expect(prov2, isNot(equals(prov1)));
      expect(prov1.name, equals(name));
      expect(prov2.name, equals(name));
    });
  });
}

class MockConfig extends BaseConfig {
  MockConfig(super.env);
}

class MockProvider {
  MockProvider(this.config);
  final MockConfig config;
  String get name => config.getOrThrow('name');
}

class MockSingleton {
  MockSingleton(this.config);
  final MockConfig config;
  String get name => config.getOrThrow('name');
}

class MockRegistry extends Registry<MockConfig> {
  @override
  void setup(MockConfig config) {
    // Register default implementations here
    injector
      ..clearAll()
      ..registerSingleton<MockConfig>(() => config)
      ..register(withConfig(
        (config) => MockSingleton(config),
        singleton: true,
      ))
      ..register(withConfig(
        (config) => MockProvider(config),
        singleton: false,
      ));
  }

  MockSingleton get singleton => injector.get<MockSingleton>();

  MockProvider provider() => injector.get<MockProvider>();
}
