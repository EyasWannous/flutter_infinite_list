import 'package:equatable/equatable.dart';

final class Post extends Equatable {
  const Post({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;

  @override
  List<Object> get props => [id, title, body];

  static Post fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  static List<Post> getPosts(List<dynamic> posts) {
    List<Post> result = [];

    for (var post in posts) {
      result.add(Post.fromJson(post));
    }

    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}
