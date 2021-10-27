import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/control_button.dart';

import 'direction.dart';

class ControlPanel extends StatelessWidget {
  final void Function(Direction direction) onTapped;
  const ControlPanel({Key? key,required this.onTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 50.0,
        child: Row(
      children: [
        Expanded(child: Row(
          children: [
            Expanded(child: Container()),
            ControlButton(onPresed: (){
              onTapped(Direction.left);
            }, icon: Icon(Icons.arrow_left)
            ),
          ],
        )),
        Expanded(child: Column(
          children: [
            ControlButton(onPresed: (){
              onTapped(Direction.up);
            }, icon: Icon(Icons.arrow_drop_up)
            ),
            SizedBox(
              height: 70,
            ),
            ControlButton(onPresed: (){
              onTapped(Direction.down);
              },
              icon: Icon(Icons.arrow_drop_down),
            )
          ],
        ),),
        Expanded(child: Row(
          children: [
            ControlButton(onPresed: (){
              onTapped(Direction.right);
            }, icon: Icon(Icons.arrow_right)
            ),
            Expanded(child: Container()),
          ],
        )),
      ],

    ));
  }
}
