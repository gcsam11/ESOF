import 'package:flutter_test/flutter_test.dart';
import 'package:tree_designer/components/person_window.dart';

void main() {
  group('Capitalize Function', () {
    test('capitalize function test - single word', () {
      final String result = capitalize('hello');
      expect(result, 'Hello');
    });

    test('capitalize function test - multiple words', () {
      final String result = capitalize('hello world');
      expect(result, 'Hello world');
    });

    test('capitalize function test - empty string', () {
      final String result = capitalize('');
      expect(result, '');
    });

    test('capitalize function test - upper case string', () {
      final String result = capitalize('HELLO');
      expect(result, 'HELLO');
    });
  });
}