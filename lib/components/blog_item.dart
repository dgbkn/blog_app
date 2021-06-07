import 'package:flutter/material.dart';

class BlogListItem extends StatelessWidget {
  const BlogListItem({
    this.label,
    this.title,
    this.imageUrl,
    this.publishedTime,
    this.onPressed,
    this.id,
    Key key,
  }) : super(key: key);

  final String title;
  final String label;
  final id;

  final String imageUrl;
  final Function onPressed;
  final DateTime publishedTime;

  String getTime() {
    Duration difTime = DateTime.now().difference(publishedTime);
    var month = difTime.inDays ~/ 30;
    var year = month ~/ 12;

    if (year > 0) {
      return year.toString() + ' years ago';
    }
    if (month > 0) {
      return month.toString() + ' months ago';
    }
    if (difTime.inDays > 0) {
      return difTime.inDays.toString() + ' days ago';
    }
    if (difTime.inDays == 0) {
      return difTime.inHours.toString() + ' hours ago';
    }
    if (difTime.inHours == 0) {
      return difTime.inMinutes.toString() + ' minutes ago';
    }
    if (difTime.inMinutes == 0) {
      return difTime.inSeconds.toString() + ' seconds ago';
    }

    return 'not date';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
     
      margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  imageUrl == null
                      ? Container()
                      : Hero(
                          tag: id,
                          child: Image.network(
                            imageUrl ??
                                'https://1.bp.blogspot.com/-wYaH50iN2Gc/VkrNGC0kiSI/AAAAAAAAAas/_Y46G9dOXnc/s640/Untitled-1.png',
                            width: 150,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            title ??
                                'Quisque sed risus sed felis efficitur tincidunt',
                            style: TextStyle(fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 3,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.label,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      label ?? 'Label',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  publishedTime != null
                                      ? getTime()
                                      : '10/10/2019',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
