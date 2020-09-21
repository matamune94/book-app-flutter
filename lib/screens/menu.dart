import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/global.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'removeAds.dart';
import 'settingBook.dart';
import 'rate.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  dynamic _menu = G.fireBaseService.getConfig(prop: 'menu');
  String _blankImage = 'https://live.staticflickr.com/65535/50253147833_87b30e42e1_q_d.jpg';

  @override
  void initState() {
    _menu.add({
      'title': 'Đánh giá sản phẩm',
      'type': 'push',
      'content': '',
      'icon': 'https://live.staticflickr.com/65535/50253699073_744fe9caa5_q_d.jpg'
    });
    _menu.add({
      'title': 'Xóa quảng cáo',
      'type': 'remove_ads',
      'icon': 'https://live.staticflickr.com/65535/50253165783_30a3e63820_q_d.jpg'
    });
    _menu.add({
      'title': 'Cài đặt sách',
      'type': 'setting_book',
      'icon': 'https://live.staticflickr.com/65535/50253837756_78550afaa5_q_d.jpg'
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tùy chọn'),
      ),
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: _menu.length,
          itemBuilder: (context, i){
            return _buildRow(_menu[i]);
          }
        ),
      ),
    );
  }
  
  _buildRow(item){
    return GestureDetector(
      onTap: (){
        _onTapItem(item);
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (BuildContext context) {
        //   return _ViewContentMenu(item: item,);
        // }));
      },
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Image.network(item['icon'] ?? _blankImage, height: 40.0, width: 40.0,),
              ),
              SizedBox(width: 10.0,),
              Expanded(child: Text(item['title'])),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
          Divider(height: 1.0,)
        ],
      ),
    );
  }

  _onTapItem(item){
    switch (item['type']) {
      case 'remove_ads':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return RemoveAdsScreen();
        }));
        break;
      case 'setting_book':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return SettingBookScreen();
        }));
        break;
      case 'push':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return RateScreen();
        }));
        break;
      default: Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ViewHtml(item: item);
        }));
    }
  }
}

class ViewHtml extends StatefulWidget {
  ViewHtml({Key key, this.item}) : super(key: key);
  final dynamic item;
  @override
  _ViewHtmlState createState() => _ViewHtmlState();
}

class _ViewHtmlState extends State<ViewHtml> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.item['title']),
      ),
      body: WebView(
        initialUrl: Uri.dataFromString(widget.item['content'] ?? '', mimeType: 'text/html').toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      )
    );
  }
}