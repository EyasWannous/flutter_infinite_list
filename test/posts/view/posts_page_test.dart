import 'package:flutter/material.dart';
import 'package:flutter_infinite_list/posts/posts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostsPage', () {
    testWidgets('renders PostList', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PostsPage()));
      await tester.pumpAndSettle();
      expect(find.byType(PostsList), findsOneWidget);
    });
  });
}
