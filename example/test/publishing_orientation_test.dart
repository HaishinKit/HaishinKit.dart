import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit_example/publishing_orientation.dart';

void main() {
  test(
    'portrait and landscape use the same pixels with inverted dimensions',
    () {
      final portrait = publishingSize(Orientation.portrait);
      final landscape = publishingSize(Orientation.landscape);
      expect(portrait.width, landscape.height);
      expect(portrait.height, landscape.width);
      expect(landscape.width, greaterThan(landscape.height));
      expect(portrait.width * portrait.height, 1280 * 720);
    },
  );
}
