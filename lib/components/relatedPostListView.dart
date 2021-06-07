import 'package:flutter/material.dart';
import 'package:googleapis/blogger/v3.dart';
import 'package:blogger_flutter/model/blogModel.dart';
import 'package:provider/provider.dart';
import 'package:blogger_flutter/screens/post_screen.dart';

BlogModelNotifier _blogModelNotifier;

class RelatedPostViewBuilder extends StatefulWidget {
  const RelatedPostViewBuilder({
    Key key,
    @required this.postList,
  }) : super(key: key);

  final PostList postList;

  @override
  _RelatedPostViewBuilderState createState() => _RelatedPostViewBuilderState();
}

class _RelatedPostViewBuilderState extends State<RelatedPostViewBuilder> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _blogModelNotifier = Provider.of<BlogModelNotifier>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            'Related Posts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.postList.items.length,
              itemBuilder: (context, index) {
                return RelatedPostCard(
                  post: widget.postList.items[index],
                );
              },
            )),
        SizedBox(
          height: 80,
        )
      ],
    );
  }
}

class RelatedPostCard extends StatelessWidget {
  const RelatedPostCard({Key key, @required this.post})
      : super(key: key);

  final Post post;


  @override
  Widget build(BuildContext context) {
   
    return  _blogModelNotifier.currentPostId == post.id ? Container() : _postList(context);
  }

  _postList(BuildContext context) {
   
    return Container(
      height: 230,
      child: RawMaterialButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) =>
                    PostScreen(isLoadPostbyId: true, postId: post.id)),
          );
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 2,
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                child: Image.network(post.images.first.url, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 200,
                  child: Text(
                    post.title,
                    style: TextStyle(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
