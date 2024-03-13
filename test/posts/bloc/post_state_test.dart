import 'package:flutter_infinite_list/posts/posts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostState', () {
    test('supports value comparison', () {
      expect(const PostState(), const PostState());
      expect(
        const PostState().toString(),
        const PostState().toString(),
      );
    });
  });
}
