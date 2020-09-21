import 'package:flutter/material.dart';

class BtnReadBook extends StatefulWidget {
  BtnReadBook({Key key}) : super(key: key);

  @override
  _BtnReadBookState createState() => _BtnReadBookState();
}

class _BtnReadBookState extends State<BtnReadBook> with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200)
    );

    _animation = Tween(begin: 0.9, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut))
    ..addListener(() {
      setState(() {});
    })
    ..addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.completed){
        // print('object');
        _animationController.reverse(from: 1.0);
      } 
      else if (status == AnimationStatus.dismissed) {
        _animationController.forward(from: 0.0);
      }
    });

    _animationController.forward(from: 0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Transform.scale(
         scale: _animation.value,
         child: Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(80.0),
             color: Colors.white,
             boxShadow: [
               BoxShadow(
                color: Colors.black.withOpacity(0.8),
                spreadRadius: 1,
                blurRadius: 4,
                // offset: Offset(0, 3),
               )
             ]
           ),
           width: 150.0,
           height: 150.0,
           child: Center(
             child: Text(
               'Đọc ngay',
               style: TextStyle(
                 color: Colors.orange,
                 fontSize: 25.0,
                 fontWeight: FontWeight.bold
               ),
            ),
           ),
          //  color: Colors.red,
         ),
      ),
    );
  }
}