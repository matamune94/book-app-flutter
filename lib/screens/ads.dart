
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdsScreen extends StatefulWidget {
  AdsScreen({Key key, this.content}) : super(key: key);
  final dynamic content;

  @override
  _AdsScreenState createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  Timer _timer;
  int _start = 10;

  @override
  void initState() {
    super.initState();
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _start > 1 ? false : true,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: Uri.dataFromString(widget.content['html'], mimeType: 'text/html').toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _startTimer();
                  _controller.complete(webViewController);
                },
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: _start > 1
              ? Stack(
                children: [
                  CircularProgressIndicator(
                    value: _start / 10,
                    backgroundColor: Colors.grey,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    top: 0,
                    left: 0,
                    child: Center(
                      child: Text('$_start'),
                    )
                  )
                ],
              )
              : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.grey
                ),
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}