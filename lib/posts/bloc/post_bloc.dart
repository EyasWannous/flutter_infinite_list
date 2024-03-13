import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_infinite_list/posts/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required this.httpClient, required this.scrollController})
      : super(const PostState()) {
    on<PostFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    scrollController.addListener(_onScroll);
  }

  static const throttleDuration = Duration(milliseconds: 100);
  static EventTransformer<E> throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return droppable<E>().call(events.throttle(duration), mapper);
    };
  }

  final http.Client httpClient;
  static const _postLimit = 20;

  final ScrollController scrollController;

  void _onScroll() {
    if (_isBottom) add(PostFetched());
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;

    final double maxScroll = scrollController.position.maxScrollExtent;
    final double currentScroll = scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await _fetchPosts();
        return emit(
          state.copyWith(
            status: PostStatus.success,
            posts: posts,
            hasReachedMax: false,
          ),
        );
      }
      final posts = await _fetchPosts(state.posts.length);
      emit(
        posts.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: PostStatus.success,
                posts: state.posts..addAll(posts),
                hasReachedMax: false,
              ),
      );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    Map<String, String> queryParameters = {
      '_start': '$startIndex',
      '_limit': '$_postLimit',
    };

    final postRequest = Uri.https(
      'jsonplaceholder.typicode.com',
      '/posts',
      queryParameters,
    );

    final http.Response response = await httpClient.get(postRequest);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as List;
      final result = Post.getPosts(body);
      return result;
    }

    throw Exception('Error fetching posts in post_Bloc');
  }

  @override
  Future<void> close() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    return super.close();
  }
}
