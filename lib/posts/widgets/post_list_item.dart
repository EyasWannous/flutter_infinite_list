import 'package:flutter/material.dart';
import 'package:flutter_infinite_list/posts/models/post.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final themeText = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        isThreeLine: true,
        dense: true,
        title: Text(
          post.title,
          style: themeText.titleLarge,
        ),
        leading: Text(
          '${post.id}',
          style: themeText.titleSmall,
        ),
        subtitle: Text(
          post.body,
          style: themeText.bodyMedium,
        ),
      ),
    );
  }
}
