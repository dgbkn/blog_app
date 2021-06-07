import 'package:flutter/foundation.dart';
import 'package:googleapis/blogger/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:blogger_flutter/constants.dart';

class BlogModelNotifier with ChangeNotifier {
  bool isLoaded = false;

  Blog blog;
  List<Post> posts = [];
  String currentPostId;

  BloggerApi _bloggerApi = BloggerApi(clientViaApiKey(kApiKey));

  Future<Blog> fetchBlog() async {
    blog = await _bloggerApi.blogs
        .getByUrl(
          kBlogUrl,
        )
        .catchError((onError) => print(onError));
    return blog;
  }

  Future<PostList> getPost({String pageToken}) async {
    final postlist = await _bloggerApi.posts
        .list(blog.id, fetchImages: true, pageToken: pageToken ?? null);
    return postlist;
  }

  Future<PostList> searchPostByQ(String q) async {
    var result = await _bloggerApi.posts.search(blog.id, q);
    if (result.items == null) {
      return null;
    }
    return result;
  }

  changeState(bool state) {
    isLoaded = state;
    notifyListeners();
  }

  Future getPostByID({String id}) async {
    try {
      final Post post = await _bloggerApi.posts
          .get(blog.id, id, fetchImages: true, fetchBody: true);
      return post;
    } catch (e) {
      throw 'eroo';
    }
  }

  Future<dynamic> getRelatedPosts(String label) async {
    try {
      return await _bloggerApi.posts
          .list(blog.id, labels: label, fetchImages: true);
    } catch (e) {
      return null;
    }
  }
}
