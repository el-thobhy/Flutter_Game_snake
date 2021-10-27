import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/control_panel.dart';
import 'package:flutter_game/piece.dart';

import 'direction.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  late int upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  late double screenWidth, screenHeight;
  int step = 20;

  int length=5;
  List<Offset> position = [];
  Offset? foodPosition;
  Piece? food;
  int score=0;
  double speed=0.0;
  Direction direction = Direction.right;
  Timer? timer;
  void changeSpeed(){

    if(timer!=null&&timer!.isActive){
      timer!.cancel();
    }

    timer=Timer.periodic(Duration(milliseconds: 200 ~/speed), (timer) {
      setState(() {

      });
    });
  }

  Widget getControl(){
    return ControlPanel(
        onTapped: (Direction newdirection){
          direction= newdirection;
    });
  }

  Direction getRandomDirection(){
    int val=Random().nextInt(4);
    direction=Direction.values[val];
    return direction;
  }

  void restart(){
    length=5;
    score=0;
    speed=1;
    position=[];
    direction=getRandomDirection();
    changeSpeed();
  }

  @override
  initState(){
    super.initState();
    restart();
  }

  int getNearestTens(int num) {
    int output;
    output = (num ~/ step) * step; //20.4 (408/20)
    if (output == 0) {
      output += step;
    }
    return output;
  }

  Offset getRandomPosition() {
    Offset position;
    int postX = Random().nextInt(upperBoundX) + lowerBoundX;
    int postY = Random().nextInt(upperBoundY) + lowerBoundY;
    position = Offset(
        getNearestTens(postX).toDouble(), getNearestTens(postY).toDouble());
    return position;
  }

  void draw() async{
    if (position.isEmpty) {
      position.add(getRandomPosition());
    }
    while(length>position.length){
      position.add(position[position.length-1]);
    }
    for(var i=position.length-1;i>0;i--){
      position[i]=position[i-1];
      //4<--3
      //3<--2
      //2<--1
      //1<--0
    }
    position[0]=await getNextPosition(position[0]);
  }
  
  void showGameOverDialog(){
    showDialog(
      context: context,
      builder: (ctx) {  
        return AlertDialog(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 3.0
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          title: Text(
            "Waang Mati",
            style: TextStyle(
              color: Colors.white),
          ),
          content: Text(
            "mantap yuang, ko score ang "+score.toString(),
                style: TextStyle(color: Colors.white,fontSize: 20),
          ),
          actions: [
            TextButton(onPressed: ()async{
              Navigator.of(context).pop();
              restart();
            }, child: Text(
              "Restart",
              style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),
            ))
          ],
        );
    }, 
        
      
    );
  }
  
  Future<Offset> getNextPosition(Offset position) async{
    Offset? nextPosition;
    if(direction==Direction.right){
      nextPosition=Offset(position.dx+step,position.dy);
    }else if(direction==Direction.left){
      nextPosition=Offset(position.dx-step, position.dy);
    }else if(direction==Direction.up){
      nextPosition=Offset(position.dx,position.dy-step);
    }else if(direction==Direction.down){
      nextPosition=Offset(position.dx, position.dy+step);
    }
    if(detectCollision(position)==true){
      if(timer != null&&timer!.isActive){
        timer!.cancel();
      }
     await Future.delayed(
        Duration(milliseconds: 200),
          ()=>showGameOverDialog()
      );
     return position;
    }
    return nextPosition!;
  }

  void drawFood(){
    if(foodPosition==null){
      foodPosition=getRandomPosition();
    }
    if(foodPosition==position[0]){
      length++;
      score =score+ 5;
      speed=speed+0.50;
      foodPosition=getRandomPosition();
    }
    food=Piece(
      posX: foodPosition!.dx.toInt(),
      posY: foodPosition!.dy.toInt(),
      size: step,
      color: Colors.orange,
      isAnimated: true,
    );
  }

  bool detectCollision(Offset position){
    if(position.dx>=upperBoundX&&direction==Direction.right){
      return true;
    }else if(position.dx<=lowerBoundX&&direction==Direction.left){
      return true;
    }else if(position.dy>=upperBoundY&&direction==Direction.down){
      return true;
    }else if(position.dy<=lowerBoundY&&direction==Direction.up){
      return true;
    }
    return false;
  }

  List<Piece> getPieces(){
    final piece=<Piece>[];
    draw();
    drawFood();
    for(var i=0;i<length;++i){
      if(i>=position.length){
        continue;
      }
      piece.add(Piece(
        posX: position[i].dx.toInt(),
        posY: position[i].dy.toInt(),
        size: step,
        color: Colors.white,
        isAnimated: true,

      ));
    }

    return piece;
  }

  Widget getScore(){
    return Positioned(
        top: 80.0,
        right: 50.0,
        child: Text(
      "Score :"+score.toString(),
      style: TextStyle(fontSize: 30,color: Colors.white),
    ));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight=MediaQuery.of(context).size.height;
    screenWidth=MediaQuery.of(context).size.width;
    lowerBoundX=step;
    lowerBoundY=step;

    upperBoundX=getNearestTens(screenWidth.toInt()-step);//906
    upperBoundY=getNearestTens(screenHeight.toInt()-step);//408
    return Scaffold(
      body:Container(
        color:Colors.black,
        child:Stack(
          children: [
            Stack(
              children: getPieces(),
            ),
            getControl(),
            food!,
            getScore()
          ],
        )
      )
    );
  }
}

