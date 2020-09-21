import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';

class RateScreen extends StatefulWidget {
  RateScreen({Key key}) : super(key: key);

  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {

  String appID = "";
  String output = "";

  @override
  void initState() {
    super.initState();
    AppReview.getAppID.then((String onValue) {
      setState(() {
        appID = onValue;
      });
      print("App ID" + appID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: const Text('Đánh giá sản phẩm')
      ),
      body: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Container(
              height: 40.0,
            ),
            new ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App ID'),
              subtitle: new Text(appID),
              onTap: () {
                AppReview.getAppID.then((String onValue) {
                  setState(() {
                    output = onValue;
                  });
                  print(onValue);
                });
              },
            ),
            const Divider(height: 20.0),
            new ListTile(
              leading: const Icon(
                Icons.shop,
              ),
              title: const Text('View Store Page'),
              onTap: () {
                AppReview.storeListing.then((String onValue) {
                  setState(() {
                    output = onValue;
                  });
                  print(onValue);
                });
              },
            ),
            const Divider(height: 20.0),
            new ListTile(
              leading: const Icon(
                Icons.star,
              ),
              title: const Text('Request Review'),
              onTap: () {
                AppReview.requestReview.then((String onValue) {
                  setState(() {
                    output = onValue;
                  });
                  print(onValue);
                });
              },
            ),
            const Divider(height: 20.0),
            new ListTile(
              leading: const Icon(
                Icons.note_add,
              ),
              title: const Text('Write a New Review'),
              onTap: () {
                AppReview.writeReview.then((String onValue) {
                  setState(() {
                    output = onValue;
                  });
                  print(onValue);
                });
              },
            ),
            const Divider(height: 20.0),
            // new ListTile(title: new Text(output)),
          ],
        ),
      ),
    );
  }
}