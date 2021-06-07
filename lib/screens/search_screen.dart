import 'package:flutter/material.dart';
import 'package:googleapis/blogger/v3.dart' show PostList;
import 'package:blogger_flutter/components/search_item.dart';
import 'post_screen.dart';

import 'package:blogger_flutter/model/blogModel.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  BlogModelNotifier _blogModelNotifier;

  PostList _postList;
  bool isLoading = false;
  String text = 'Search Post';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _blogModelNotifier = Provider.of<BlogModelNotifier>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: TextField(
          onChanged: (a) async {
            if (a.length > 0) {
              this.text = 'Could not find searched post';
            } else {
              this.text = 'Search Posts';
            }
            setState(() {
              isLoading = true;
            });
            var result = await _blogModelNotifier.searchPostByQ(a);
            setState(() {
              _postList = result;
              isLoading = false;
            });
          },
          autofocus: true,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: _postList != null
          ? Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var post = _postList.items[index];
                      return SearchItem(
                        title: post.title,
                        id: post.url,
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return PostScreen(
                              isLoadPostbyId: true,
                              postId: post.id,
                            );
                          }));
                        },
                      );
                    },
                    itemCount: _postList.items.length,
                  ),
                ),
                SizedBox(
                  height: 60,
                )
              ],
            )
          : Center(
              child: isLoading ? CircularProgressIndicator() : Text(text),
            ),
    );
  }
}
