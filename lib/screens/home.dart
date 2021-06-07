import 'package:flutter/material.dart';
import 'package:googleapis/blogger/v3.dart';
import 'post_screen.dart';
import 'search_screen.dart';
import 'package:blogger_flutter/components/blog_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:blogger_flutter/model/blogModel.dart';
import 'package:blogger_flutter/screens/bookmark_screen.dart';
import 'package:blogger_flutter/helpers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class HomePage extends StatefulWidget {
  static const String id = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Blog blog;
  PostList postList;
  String token;
  List<Post> posts = [];
  BlogModelNotifier _blogModelNotifier;

  bool isLoaded = false;
  bool loadMore = false;
  getBlog({String pagetoken}) async {
    try {
      blog = await _blogModelNotifier.fetchBlog();

      postList = await _blogModelNotifier.getPost(
        pageToken: pagetoken ?? null,
      );

      for (var post in postList.items) {
        posts.add(post);
      }
      token = postList.nextPageToken;
      setState(() {
        isLoaded = true;
        loadMore = false;
      });
    } catch (e) {
      setState(() {
        loadMore = false;
      });
      print(e);
    }
  }

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getBlog(pagetoken: token);
        setState(() {
          loadMore = true;
        });
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _blogModelNotifier = Provider.of<BlogModelNotifier>(context);
    if (posts.isEmpty) {
      getBlog();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded) {
      return Scaffold(
      bottomNavigationBar: !kIsWeb ? loadAdmobBanner() : SizedBox(),
        drawer: buildDrawer(context),
        appBar: AppBar(
          title: Text(
            blog.name.toString(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.bookmark),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => BookmarkPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: posts.length,
                itemBuilder: (BuildContext context, index) {
                  var post = posts[index];

                  return BlogListItem(
                    id: post.url,
                    title: post.title,
                    imageUrl:
                        post.images == null ? null : post.images.first.url,
                    label: post.labels == null
                        ? 'No category'
                        : post.labels.first.toString(),
                    publishedTime: DateTime.parse(post.published),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return PostScreen(
                          post: post,
                        );
                      }));
                    },
                  );
                },
              ),
            ),
            loadMore
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    } else {
      return _loadingScreen(context);
    }
  }

  buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  blog.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  blog.description ?? '',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                )
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
            },
            title: Text('Home'),
            leading: Icon(Icons.home),
          ),
          ListTile(
            onTap: () async {
              var url = blog.url;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
              Navigator.of(context).pop();
            },
            title: Text('Visit Website'),
            leading: Icon(Icons.link),
          )
        ],
      ),
    );
  }

  Widget _loadingScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
