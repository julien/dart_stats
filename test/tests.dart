import 'dart:html';
import 'packages/unittest/unittest.dart';
import 'packages/unittest/html_enhanced_config.dart';
import '../lib/dart_stats.dart';

void main() {
  // this fails ...
  // useHtmlEnhancedConfiguration();

  group('basic tests', () {
    Stats stats = new Stats();
    stats.mode = 1;

    test('stats.domElement() returns an Element', () {
      expect (stats.domElement() is Element, equals(true));
    });
  });

}


