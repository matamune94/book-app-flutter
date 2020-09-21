import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/chapters.dart';
import 'screens/readChapter.dart';
import 'screens/menu.dart';
import 'utils/global.dart';
import 'screens/loading.dart';

const bookKey = 'ai_lam_duoc';
const appAdId = 'ca-app-pub-7281292657312277~9661317779';
const interstitialAdId = 'ca-app-pub-7281292657312277/1846422840';

const EVENTS_KEY = "fetch_events";
void backgroundFetchHeadlessTask(String taskId) async {
  print("[BackgroundFetch] Headless event received: $taskId");
  DateTime timestamp = DateTime.now();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Read fetch_events from SharedPreferences
  List<String> events = [];
  String json = prefs.getString(EVENTS_KEY);
  if (json != null) {
    events = jsonDecode(json).cast<String>();

  }
  // Add new event.
  events.insert(0, "$taskId@$timestamp [Headless]");
  // Persist fetch events in SharedPreferences
  prefs.setString(EVENTS_KEY, jsonEncode(events));

  dynamic book = await G.func.readStorage('book');
  dynamic bookmark = await G.func.readStorage('bookmark');
  if(bookmark != null){
    G.localNotifications.showNotification(
      title: book != null ? book['title'] : 'Sách hay', 
      body: 'Bạn đã đọc hết sách chưa ? Hãy tiếp tục đọc phần sách mà bạn đã lưu vào bookmark', 
      payload: 'pushToReadChapter'
    );
  } else {
    G.localNotifications.showNotification(
      title: book != null ? book['title'] : 'Sách hay', 
      body: 'Vào Book store để tìm sách hay nào.',
    );
  }

}
void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({Key key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp>  with WidgetsBindingObserver {

  bool _loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initData();
    _initBackgroundState();
    G.localNotifications.initLocalNotification(_initLocalNotification);
    BackgroundFetch.stop().then((int status) {
      print('[BackgroundFetch] stop success: $status');
    });
    super.initState();
  }

  _initData() async {
    await G.purchaseService.init();
    await G.fireBaseService.init();
    await G.fireBaseService.initConfig();
    var book = await G.func.readStorage('book');
    if(book == null){
      await G.fireBaseService.getData(bookKey, (data) async {
        await G.func.writeStorage('book', data);
        G.fireBaseService.setBook(data);
      });
    } else {
      G.fireBaseService.setBook(book);
    }
    await G.func.init();
    G.admonService.init(appAdId, interstitialAdId: interstitialAdId);
    _loading = false;
    setState(() {});
  }

  Future<void> _initBackgroundState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        forceAlarmManager: false,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
    ), (String taskId) async {
      // print(['eo hieu', taskId]);
        switch (taskId) {
          case 'flutter_background_fetch':
            BackgroundFetch.scheduleTask(TaskConfig(
                startOnBoot: true,
                taskId: "flutter_background_fetch",
                delay: 12 * 60 * 60,
                periodic: false,
                forceAlarmManager: true,
                stopOnTerminate: false,
                enableHeadless: true
            ));
            break;
          default: print("Default fetch task");
            // Handle the default periodic fetch task here///
        }
      BackgroundFetch.finish(taskId);
    }).then((int status) {

    }).catchError((e) {
      
    });
    if (!mounted) return;
  }

  _initLocalNotification(payload) {
    print(['payload', payload]);
    if(payload != null){
      switch (payload) {
        case 'pushToReadChapter':
          _pushToReadChapter();
          break;
        default: print('Notification with no payload');
      }
    }
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print('App resumed');
        BackgroundFetch.stop().then((int status) {
          print('[BackgroundFetch] stop success: $status');
        });
        break;
      case AppLifecycleState.paused:
        print('App paused');
        break;
      case AppLifecycleState.inactive:
        print('App inactive');
        break;
      case AppLifecycleState.detached:
        print('App detached');
        break;
      default: print('other app state');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
    ? LoadingScreen()
    : MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Đọc sách hay',
      onGenerateRoute: (RouteSettings settings){
        var routes = <String, WidgetBuilder>{
        '/': (ctx) => HomeScreen(),
        '/menu': (ctx) => MenuScreen(),
        '/listChapter': (ctx) => ChaptersScreen(),
        '/readChapter': (ctx) => ReadChapterScreen(settings.arguments)
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
    );
  }

  _pushToReadChapter() async {
    dynamic _d = await G.func.readStorage('bookmark');
    if(_d != null){
      Navigator.pushNamed(context, '/readChapter', arguments: _d);
    } 
  }
}