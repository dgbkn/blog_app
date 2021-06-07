import 'package:flutter/material.dart';
import 'package:googleapis/blogger/v3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:share/share.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:blogger_flutter/model/blogModel.dart';
import 'package:blogger_flutter/helpers.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:blogger_flutter/components/relatedPostListView.dart';

BlogModelNotifier _blogModelNotifier;

class PostScreen extends StatefulWidget {
  PostScreen({this.post, this.isLoadPostbyId = false, this.postId});

  final Post post;
  final bool isLoadPostbyId;
  final String postId;

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<String> bookmarkedPostList;
  bool _isBookmarked = false;
  SharedPreferences prefs;
  PostList relatedPostList;
  Map<String, dynamic> mapBookmark;
  Post _post;
  bool isPostLoaded = false;
  bool _isRelatedLoaded = false;

  @override
  void initState() {
    super.initState();

    if (!this.widget.isLoadPostbyId) {
      _post = widget.post;
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    widget.isLoadPostbyId ? isPostLoaded = false : isPostLoaded = true;

    prefs = await SharedPreferences.getInstance();

    _blogModelNotifier = Provider.of<BlogModelNotifier>(context, listen: false);
    if (widget.isLoadPostbyId) {
      await getPostById();
    }

    final data = prefs.get('mapPost') ?? null;
    if (data == null) {
      mapBookmark = {};
    } else {
      mapBookmark = jsonDecode(data);
    }
    setState(() {
      _isBookmarked = mapBookmark.containsKey(_post.id);
    });
    _blogModelNotifier.currentPostId = _post.id;
    getRelatedPost();
  }

  getPostById() async {
    _post = await _blogModelNotifier.getPostByID(id: widget.postId);
    setState(() {
      isPostLoaded = true;
    });
  }

  getRelatedPost() async {
    relatedPostList =
        await _blogModelNotifier.getRelatedPosts(_post.labels.first);
    try {
      setState(() {
        _isRelatedLoaded = true;
      });
    } catch (e) {}
  }

  saveBookmark() async {
    if (_isBookmarked) {
      mapBookmark.remove(_post.id);

      setState(() {
        _isBookmarked = false;
      });
    } else {
      mapBookmark.addAll(
        {_post.id: _post.title},
      );
      setState(() {
        _isBookmarked = true;
      });
    }
    await prefs.setString(
      'mapPost',
      jsonEncode(mapBookmark),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isPostLoaded ? buildScaffold() : buildLoading();
  }

  buildLoading() {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  buildScaffold() {
    return Scaffold(
      bottomNavigationBar: !kIsWeb ? loadAdmobBanner() : SizedBox(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            snap: false,
            pinned: true,
            title: Text(''),
            expandedHeight: 220.0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () async {
                  await Share.share('${_post.title} \n ${_post.url}');
                },
              ),
              Builder(builder: (context) {
                return IconButton(
                  icon: Icon(
                      _isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                  onPressed: () async {
                    await saveBookmark();

                    final snackBar = SnackBar(
                      duration: Duration(milliseconds: 500),
                      content:
                          Text(_isBookmarked ? 'Bookmarked' : 'Unbookmarked'),
                    );

                    // Find the Scaffold in the widget tree and use
                    // it to show a SnackBar.

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                );
              }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: _post.url,
                child: Image.network(
                  _post.images == null ? '' : _post.images.first.url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(_sliverListBuilder()),
          ),
          SliverToBoxAdapter(
              child: _isRelatedLoaded
                  ? RelatedPostViewBuilder(postList: relatedPostList)
                  : Container()),
        ],
      ),
    );
  }

  List<Widget> _sliverListBuilder() {
    return [
      titleAndContent(),
      SizedBox(
        height: 10,
      ),
    ];
  }

  Padding titleAndContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _post.title,
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                fontFamily: 'Raleway',
                height: 1.2),
          ),
          SizedBox(
            height: 10,
          ),
          HtmlWidget(
            _post.content,
            webView: true,
            textStyle: TextStyle(
              height: 1.5,
              fontSize: 16,
              fontFamily: 'Raleway',
            ),
          ),
        ],
      ),
    );
  }
}
