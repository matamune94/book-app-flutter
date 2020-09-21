
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AdsScreen extends StatefulWidget {
  AdsScreen({Key key, this.data}) : super(key: key);
  final dynamic data;

  @override
  _AdsScreenState createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  int timeLeft = 5;

  Timer _timer;
  int _start = 10;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
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
      onWillPop: () async => false,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Html(data: widget.data ?? ''),
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

                }
              ),
            )
          )
        ],
      ),
    );
  }
}