import 'package:flutter/material.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    this.label,
    this.title,
    this.imageUrl,
    this.updatedTime,
    this.onPressed,
    this.id,
    Key key,
  }) : super(key: key);

  final String title;
  final String label;
  final id;

  final String imageUrl;
  final Function onPressed;
  final String updatedTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: Text(
                  title ?? '',
                  style: TextStyle(fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
