import 'package:flutter/material.dart';

class ChapterCard extends StatefulWidget {
  ChapterCard({Key key, this.data}) : super(key: key);
  final dynamic data;

  @override
  _ChapterCardState createState() => _ChapterCardState();
}

class _ChapterCardState extends State<ChapterCard> {
  
  _Book _book;
  String _noImage = 'https://live.staticflickr.com/65535/50253147838_94a77bd0a7_o_d.png';

  @override
  void initState() {
    // print(widget.data);
    _book = _Book.fromJson(widget.data);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                spreadRadius: 1,
                blurRadius: 4,
              )
            ]
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: _book.poster != null 
                ? Image.network(
                  _book.poster ?? _noImage,
                  height: 80.0,
                  width: 80.0,
                  fit: BoxFit.cover,
                )
                : SizedBox(
                  height: 80.0,
                )
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _book.title, 
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _book.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis
                      )
                    ],
                  ),
                )
              )
            ]
          ),
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }
}

class _Book{
  String title;
  String description;
  String poster;
  String content;
  
  _Book(this.title, this.description, this.poster, this.content);

  _Book.fromJson(Map<dynamic, dynamic> json)
    : title = json['title'] ?? '',
      description = json['description'] ?? '',
      poster = json['poster'],
      content = json['content'] ?? '';
  
  Map<dynamic, dynamic> toJson() => {
    'title': title,
    'description': description,
    'poster': poster,
    'content': content
  };
}