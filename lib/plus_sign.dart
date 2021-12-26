import 'package:flutter/material.dart';

class PlusSign extends StatelessWidget {
  final function;

  PlusSign({Key? key, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 75,
        width: 75,
        decoration:
            BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
        child: Center(
          child: Text(
            '+',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
