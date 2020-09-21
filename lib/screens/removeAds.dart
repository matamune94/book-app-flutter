import 'package:flutter/material.dart';
import '../utils/global.dart';

class RemoveAdsScreen extends StatefulWidget {
  RemoveAdsScreen({Key key}) : super(key: key);

  @override
  _RemoveAdsScreenState createState() => _RemoveAdsScreenState();
}

class _RemoveAdsScreenState extends State<RemoveAdsScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Xóa quảng cáo'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: 200.0,
                      child: Image.asset(
                        'static/images/rm_ads.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.done, size: 20.0,),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text('Loại bỏ tất cả quảng cáo khỏi ứng dụng.'),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.done, size: 20.0,),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text('Ưu tiên giải quyết các vấn đề.'),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.done, size: 20.0,),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text('Tăng khả năng trải nghiệm ứng dụng tốt hơn.'),
                        )
                      ],
                    ),
                  ],
                ),
                !G.purchaseService.verifyPurchase('remove_ads_daily') 
                ? RaisedButton(
                  child: Text('Xóa quảng cáo'),
                  onPressed: (){
                    G.purchaseService.buyProduct('remove_ads_daily');
                  }
                )
                : SizedBox()
              ],
            )
          ),
        ),
      )
    );
  }
}