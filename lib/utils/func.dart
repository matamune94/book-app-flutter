import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:url_launcher/url_launcher.dart';

class Func {
  
  final _storage = FlutterSecureStorage();

  bool _timeToShowAds = true;
  dynamic _settingBookDefault = {
    'font_size': 16.0,
    'light': true,
  };

  init() async {
    dynamic st = await readStorage('setting_book_default');
    if(st != null){
      setSettingBookDefault(st);
    }
  }

  showAds(){
    if(!_timeToShowAds){
      return false;
    } else {
      Future.delayed(Duration(seconds: 30),(){
        _timeToShowAds = true;
      });
      _timeToShowAds = false;
      return true;
    }
  }

  setSettingBookDefault(data) async {
    await writeStorage('setting_book_default', data);
    _settingBookDefault = data;
  }

  getSettingBookDefault(){
    return _settingBookDefault;
  }

  writeStorage(String key, dynamic value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  readStorage(String key) async {
    dynamic _d = await _storage.read(key: key);
    return _d != null ? jsonDecode(_d) : null;
  }

  debounce(Function func, String id, int milliseconds) {
    EasyDebounce.debounce(
      id,                 // <-- An ID for this particular debouncer
      Duration(milliseconds: milliseconds),    // <-- The debounce duration
      func             // <-- The target method
    );
  }

  debounceCancel(String id){
    EasyDebounce.cancel(id);
  }

  launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
}