import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final void Function()? onPresed;
  final Icon icon;
  const ControlButton({Key? key,required this.onPresed,required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: 0.5,
    child: Container(
  width: 80.0,
  height: 80.0,
  child: FittedBox(
    child: FloatingActionButton(
    backgroundColor: Colors.grey,
    elevation: 0,
    onPressed: this.onPresed,
    child: this.icon,
  ),
  ),
  ),
    );
  }
}
