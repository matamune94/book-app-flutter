import 'package:flutter/material.dart';
import '../widgets/chapterCard.dart';
import '../utils/global.dart';
import 'ads.dart';

class ChaptersScreen extends StatefulWidget {
  ChaptersScreen({Key key}) : super(key: key);

  @override
  _ChaptersScreenState createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  List<dynamic> _listChapter = [];
  String _title;

  @override
  void initState() {
    if(!G.purchaseService.verifyPurchase('remove_ads_daily')){
      dynamic _listAds = G.fireBaseService.getConfig(prop: 'ads');
      dynamic ads = _listAds[0];
      if(G.func.showAds()){
        if(ads != null && ads['html'] != 'google'){
          Future.delayed(Duration(milliseconds: 100), (){
            _pushToAds(ads);
          });
        } else {
          G.admonService.showInterstitialAd();
        }
      }
    }
    Future.delayed(Duration(milliseconds: 200), (){
      _getChapter();
    });
    super.initState();
  }

  _getChapter() async {
    dynamic book = await G.fireBaseService.getBook();
    if(book != null){
      _covertBook(book);
    }
  }

  _covertBook(book){
    _title = book['title'];
    dynamic chapters = book['chapters'];
    for (var i = 0; i < chapters.length; i++) {
      var item = chapters[i];
      // print(item);
      if(item != null){
        _listChapter.add(item);
      }
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.dehaze), onPressed: (){
            Navigator.pushNamed(context, '/menu');
          })
        ],
        title: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(_title ?? ''),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
        child: ListView.builder(
          itemCount: _listChapter.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: ChapterCard(data: _listChapter[i]),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/readChapter', arguments: { 'book_title': _title ,'chapter': _listChapter[i], 'offset': 0.0 });
              },
            );
          }
        )
      ),
    );
  }

  _pushToAds(ads){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return AdsScreen(content: ads);
    }));
  }
}