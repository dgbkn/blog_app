import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:blogger_flutter/model/blogModel.dart';
import 'package:blogger_flutter/screens/post_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:blogger_flutter/helpers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  SharedPreferences prefs;
  BlogModelNotifier _blogModelNotifier;
  bool loadingNewPost = false;

  Map<String, dynamic> bookmarMap;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _blogModelNotifier = Provider.of<BlogModelNotifier>(context);
    prefs = await SharedPreferences.getInstance();
    final data = prefs.get('mapPost') ?? null;
    if (data == null) {
      bookmarMap = {};
    } else {
      bookmarMap = jsonDecode(data);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loadingNewPost,
      child: Scaffold(
      bottomNavigationBar: !kIsWeb ? loadAdmobBanner() : SizedBox(),
        appBar: AppBar(
          title: Text('Bookmarks'),
        ),
        body: bookmarMap ==null
            ? _notBookMarkedScreen(context)
            : ListView.builder(
                itemCount: bookmarMap.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        bookmarMap.values.toList().reversed.toList()[index],
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () async {
                        setState(() {
                          loadingNewPost = true;
                        });
                        try {
                          final post = await _blogModelNotifier.getPostByID(
                              id: bookmarMap.keys
                                  .toList()
                                  .reversed
                                  .toList()[index]);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => PostScreen(
                                      post: post,
                                    )),
                          );
                        } catch (e) {
                          print('object');
                        }
                        setState(() {
                          loadingNewPost = false;
                        });
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _notBookMarkedScreen(BuildContext context) {
    return Center(
      child: Text('There is no bookmarked post'),
    );
  }
}
