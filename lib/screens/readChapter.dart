import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import '../utils/global.dart';
import 'ads.dart';

class ReadChapterScreen extends StatefulWidget {
  ReadChapterScreen(this.args, {Key key}) : super(key: key);
  final dynamic args;
  // final dynamic data;
  @override
  _ReadChapterScreenState createState() => _ReadChapterScreenState();
}

class _ReadChapterScreenState extends State<ReadChapterScreen> with SingleTickerProviderStateMixin {
  dynamic _settingBookDefault = G.func.getSettingBookDefault();
  ScrollController _scrollController;
  double _fontSizeValue;
  bool _light;
  bool _showToolBar = false;
  Animation<double> _toolbarAnimation;
  AnimationController _toolBarAnimationController;
  bool _firstBuild = true;
  String _bookTitle;
  dynamic _chapter;
  double _offset; 
  dynamic _beforeChap;
  dynamic _afterChap;

  @override
  void initState() {
    // final dynamic _args = ModalRoute.of(context).settings.arguments;
    if(!G.purchaseService.verifyPurchase('remove_ads_daily')){
      dynamic _listAds = G.fireBaseService.getConfig(prop: 'ads');
      dynamic ads = _listAds[1];
      if(G.func.showAds()){
        if(ads != null){
          Future.delayed(Duration(milliseconds: 100), (){
            _pushToAds(ads);
          });
        } else {
          G.admonService.showInterstitialAd();
        }
      }
    }
    
    _bookTitle = widget.args['book_title'];
    _chapter = widget.args['chapter'];
    _offset = widget.args['offset'];
    _checkNextChap();

    _light = _settingBookDefault['light'];
    _fontSizeValue = _settingBookDefault['font_size'];

    _toolBarAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
    _toolbarAnimation = Tween(begin: -90.0, end: 0.0).animate(CurvedAnimation(parent: _toolBarAnimationController, curve: Curves.easeInOut))
    ..addListener(() {
      setState(() {});
    });
    _scrollController = ScrollController();
    _scrollController.addListener((){});
    super.initState();
  }

  _checkNextChap() async {
    dynamic book = await G.fireBaseService.getBook();
    List<dynamic> chapters = book['chapters'];
    _beforeChap = _chap(chapters, -1);
    _afterChap = _chap(chapters, 1);
  }

  _chap(chapters, key){
    int idx = chapters.indexWhere((o)=> o['title'] == _chapter['title']);
    try {
      return chapters[idx + key];
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _toolBarAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 500), (){
      if (_scrollController.hasClients && _firstBuild) {
        _scrollController.animateTo(
          _offset,
          duration: Duration(microseconds: 300), 
          curve: Curves.easeOut
        );
        _firstBuild = false;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(_bookTitle),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark), 
            onPressed: (){
              _saveToBookmark(_bookTitle, _chapter);
            }
          )
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            child: Container(
              color: _light ? Colors.white : Colors.black,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Html(
                    data: _chapter['content'],
                    style: {
                      'body': Style(
                        padding: EdgeInsets.all(0.0),
                        backgroundColor: _light ? Colors.white : Colors.black,
                      ),
                      'h1': Style(
                        color: _light ? Colors.black : Colors.white,
                        textAlign: TextAlign.center,
                        fontSize: FontSize(_fontSizeValue + 12)
                      ),
                      'p': Style(
                        color: _light ? Colors.black : Colors.white,
                        fontSize: FontSize(_fontSizeValue)
                      )
                    },
                  ),
                ),
              ),
            ),
            onTap: () {
               if(_showToolBar) {
                 _toolBarAnimationController.reverse();
                 _showToolBar = false;
               } else {
                 _toolBarAnimationController.forward();
                 _showToolBar = true;
               }
            },
          ),
          Positioned(
            top:  _toolbarAnimation.value,
            right: 0,
            left: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 2,
                    blurRadius: 4,
                  )
                ]
              ),
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _beforeChap != null
                  ? SizedBox(
                    width: 140.0,
                    child: RaisedButton(
                      color: Colors.blue[400],
                      onPressed: (){
                        _nextChap(_beforeChap);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.chevron_left, color: Colors.white),
                          Text('Chap trước', style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    ),
                  )
                  : SizedBox(),
                  _afterChap != null 
                  ? SizedBox(
                    width: 140.0,
                    child: RaisedButton(
                      color: Colors.blue[400],
                      onPressed: (){
                        _nextChap(_afterChap);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Chap sau', style: TextStyle(color: Colors.white)),
                          Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
                  )
                  : SizedBox()
                ],
              ),
            )
          ),
          Positioned(
            bottom: _toolbarAnimation.value,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 2,
                    blurRadius: 4,
                  )
                ]
              ),
              padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
              height: 80.0,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Cỡ chữ:', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _fontSizeValue,
                          min: 10,
                          max: 36,
                          divisions: 24,
                          label: _fontSizeValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _fontSizeValue = value;
                            });
                            _saveSetting();
                          },
                        )
                      )
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          child: Text(
                            'Sáng', 
                            style: TextStyle(
                              color: _light ? Colors.white : Colors.black
                            ),
                          ),
                          color: _light ? Colors.blue : Colors.white,
                          onPressed: (){
                            _light = true;
                            setState(() {});
                            _saveSetting();
                          }
                        ),
                        SizedBox(width: 10.0,),
                        RaisedButton(
                          child: Text(
                            'Tối', 
                            style: TextStyle(
                              color: _light ? Colors.black : Colors.white
                            ),
                          ),
                          color: _light ? Colors.white : Colors.blue,
                          onPressed: (){
                            _light = false;
                            setState(() {});
                            _saveSetting();
                          }
                        )
                      ],
                    )
                  )
                ],
              ),
            )
          ),
        ],
      )
    );
  }

  _nextChap(ch) async {
    _chapter = ch;
    _offset = 0.0;
    await _checkNextChap();
    setState(() {});
    Future.delayed(Duration(milliseconds: 200), (){
      _scrollController.animateTo(
        0.0,
        duration: Duration(microseconds: 300), 
        curve: Curves.easeOut
      );
    });
  }

  _pushToAds(ads){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return AdsScreen(content: ads);
    }));
  }

  _saveSetting(){
    G.func.debounce(() async {
      dynamic data = {
        'font_size': _fontSizeValue,
        'light': _light
      };
      await G.func.setSettingBookDefault(data);
      // print(G.func.getSettingBookDefault());
    }, 'save_setting', 300);
  }

  _saveToBookmark(b, ch) async {
    await G.func.writeStorage(
      'bookmark',
      { 'book_title': b, 'chapter': ch, 'offset': _scrollController.offset }
    );
    showDialog(
      context: context,
      child: new AlertDialog(
        title: const Text("Thông báo"),
        content: const Text('Bạn đã lưu mục này vào bookmark'),
        actions: [
          new FlatButton(
            child: const Text("Ok"),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}