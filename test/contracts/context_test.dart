import 'package:test/test.dart';
import 'package:endaft_core/common.dart';

void main() {
  group('Contract Tests', () {
    test('Verifies Props Are Empty As Expected', () {
      final thing = FakeContract();

      expect(thing, isNotNull);
      expect(thing.props, isA<List<Object?>>());
      expect(thing.props, isEmpty);
    });

    test('Verifies Context Attach Works As Expected', () {
      final thing = FakeContract();
      final addon = FakeAddon();

      final attached = thing.attach(addon);
      expect(attached, equals(addon));
    });

    test('Verifies Context Get Works With Values As Expected', () {
      final thing = FakeContract();
      final addon = FakeAddon();

      final attached = thing.attach(addon);
      expect(attached, equals(addon));

      final gotten = thing.get<FakeAddon>();
      expect(gotten, equals(addon));
      expect(gotten, equals(attached));
    });

    test('Verifies Context Get Throws As Expected', () {
      final thing = FakeContract();

      expect(() => thing.get<FakeAddon>(), throwsA(isA<BadContextError>()));
    });

    test('Verifies Context Get Uses Handler As Expected', () {
      final thing = FakeContract();

      FakeAddon? gotten;
      FakeAddon? fallback = FakeAddon();
      expect(
        () => gotten = thing.get<FakeAddon>((_) => fallback),
        returnsNormally,
      );
      expect(gotten, equals(fallback));
    });

    test('Verifies Context Detach Works With Values As Expected', () {
      final thing = FakeContract();
      final addon = FakeAddon();

      final attached = thing.attach(addon);
      expect(attached, equals(addon));

      final gotten = thing.detach<FakeAddon>();
      expect(gotten, isNotNull);
      expect(gotten, equals(addon));
      expect(gotten, equals(attached));
    });

    test('Verifies Context Detach Works Without Values As Expected', () {
      final thing = FakeContract();
      final gotten = thing.detach<FakeAddon>();
      expect(gotten, isNull);
    });
  });
}

class FakeAddon {}

class FakeContract extends AppContract {
  @override
  Map<String, dynamic> toJson() => const <String, dynamic>{};
}
