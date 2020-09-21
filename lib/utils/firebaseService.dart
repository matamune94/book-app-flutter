import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FireBaseService{
  dynamic config;
  dynamic database;
  dynamic book;

  init() async {
    database = FirebaseDatabase.instance.reference();
  }

  initConfig() async {
    var cfg;
    try {
      cfg = await Firebase.initializeApp(
        name: 'config',
        options: FirebaseOptions(
          appId: '1:1096551605841:android:4d515c02e853cd4c1aba70',
          apiKey: 'AIzaSyDvIoi4Xg2vnlYcP4_RNji_dk72PmMz2sU',
          projectId: 'config-book-app',
          messagingSenderId: '1096551605841',
          databaseURL: 'https://config-book-app.firebaseio.com'
        )
      );
    } catch (err) {
      RegExp regExp = new RegExp(r"already exists");
      if (regExp.hasMatch(err.message)) {
        cfg = Firebase.app('config');
      }
    }
    await FirebaseDatabase(app: cfg).reference().once().then((DataSnapshot snapshot){
      config = snapshot.value;
    });
  }

  getBook(){
    return book;
  }

  setBook(data){
    book = data;
  }

  getConfig({ String prop }){
    if(prop == null){
      return config;
    } else {
      var items = config[prop];
      if(items != null){
        if(items is List){
          var data = [];
          for (var i = 0; i < items.length; i++) {
            var item = items[i];
            if(item != null) {
              data.add(item);
            }
          }
          return data;
        } else {
          return items;
        }
      }
    }
  }

  getData(String child, Function _getData) {
    var db = database.child(child);
    try {
      db.once().then((DataSnapshot snapshot){
        _getData(snapshot.value);
      });
    } catch (e) {
      print(e);
    }

  }
}