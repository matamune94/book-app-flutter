
import 'package:background_fetch/background_fetch.dart';

class BackgroundService{
  registerHeadlessTask(Function _backgroundFetchHeadlessTask){
    BackgroundFetch.registerHeadlessTask(_backgroundFetchHeadlessTask);
  }
}