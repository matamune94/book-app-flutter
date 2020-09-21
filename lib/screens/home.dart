import 'package:flutter/material.dart';
import '../widgets/btnReadBook.dart';
import '../utils/global.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _webBook = G.fireBaseService.getConfig(prop: 'web_books');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('static/images/background.jpg'),
          fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Kho Sách'),
          onPressed: () {
            G.func.launchURL(_webBook);
          },
        ),
        bottomNavigationBar: BottomAppBar(
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder()
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: (){
                  Navigator.pushNamed(context, '/menu');
                }
              ),
              IconButton(
                icon: Icon(Icons.turned_in_not), 
                onPressed: (){
                  _pushToReadChapter();
                }
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: BtnReadBook(),
                onTap: (){
                  Navigator.pushNamed(context, '/listChapter');
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _pushToReadChapter() async {
    dynamic _d = await G.func.readStorage('bookmark');
    if(_d != null){
      Navigator.pushNamed(context, '/readChapter', arguments: _d);
    } else {
      showDialog(
        context: context,
        child: new AlertDialog(
          title: const Text("Thông báo"),
          content: const Text('Bạn chưa lưu mục nào vào bookmark'),
          actions: [
            new FlatButton(
              child: const Text("Ok"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
    
  }
}