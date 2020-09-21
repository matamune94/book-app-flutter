import 'package:flutter/material.dart';
import '../utils/global.dart';

class SettingBookScreen extends StatefulWidget {
  SettingBookScreen({Key key}) : super(key: key);

  @override
  _SettingBookScreenState createState() => _SettingBookScreenState();
}

class _SettingBookScreenState extends State<SettingBookScreen> {
  dynamic _settingBookDefault = G.func.getSettingBookDefault();
  double _fontSizeValue;
  bool _light;
  bool _settingChanged = true;

  @override
  void initState() {
    _light = _settingBookDefault['light'];
    _fontSizeValue = _settingBookDefault['font_size'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cài đặt sách'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Kích cỡ chữ:'),
                Expanded(
                  child: Slider(
                    value: _fontSizeValue,
                    min: 10,
                    max: 36,
                    divisions: 24,
                    label: _fontSizeValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _settingChanged = true;
                        _fontSizeValue = value;
                      });
                    },
                  )
                )
              ],
            ),
            Row(
              children: [
                Text('Chế độ xem:'),
                SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
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
                          setState(() {
                            _settingChanged = true;
                            _light = true;
                          });
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
                          setState(() {
                            _settingChanged = true;
                            _light = false;
                          });
                        }
                      )
                    ],
                  )
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: RaisedButton(
                onPressed: _saveSettingBook,
                child: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !_settingChanged 
                      ? Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.done, color: Colors.green),
                      )
                      : SizedBox(),
                      Center(child: Text('Lưu cài đặt'),)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  void _saveSettingBook() async {
    dynamic data = {
      'font_size': _fontSizeValue,
      'light': _light
    };

    await G.func.setSettingBookDefault(data);

    setState(() {
      _settingChanged = false;
    });
  }
}