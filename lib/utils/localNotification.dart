import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();


  initLocalNotification(Function _initLocalNotification) async {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
      // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
      // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (dynamic payload) async {
      print(['what the hell with payload', payload]);
      return _initLocalNotification(payload);
    });
  }

  showNotification({
    String channelId = 'id', 
    String channelName = 'name', 
    String channelDes = 'des', 
    String sound = 'slow_spring_board',
    int id = 0,
    String title = '',
    String body = '',
    dynamic payload,
    bool schedule = false
  }) async {
    var platformChannelSpecifics = new NotificationDetails(
      _setAndroid(
        channelId: channelId,
        channelName: channelName,
        channelDes: channelDes,
        sound: sound
      ), 
      _setIOS(
        sound: sound
      )
    );
    if(schedule) {
      await flutterLocalNotificationsPlugin.schedule(
        id,
        title,
        body,
        DateTime.now().add(Duration(seconds: 0)),
        platformChannelSpecifics,
        payload: payload
      );
    } else {
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload
      );
    }

  }

  _setAndroid({String channelId, String channelName, String channelDes, String sound}){
    return AndroidNotificationDetails(
      channelId, 
      channelName, 
      channelDes,
      sound: RawResourceAndroidNotificationSound(sound),
      importance: Importance.Max, 
      priority: Priority.High, 
      ticker: 'ticker'
    );
  }

  _setIOS({String sound}){
    return IOSNotificationDetails(
      sound: '$sound.aiff'
    );
  }
}