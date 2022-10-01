import 'package:flutter/material.dart';

Widget bottomSheet(text, height, animationController, onClose){
  return BottomSheet(
          onClosing: onClose,
          enableDrag: true,
          elevation: 8,
          animationController: animationController,
          builder: (context) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuad,
              height: height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(4),
                    height:2, width:32,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[200],
                      borderRadius: BorderRadius.circular(2)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(text),
                  ),
                  Container()
                ],
              )),
            );
          });
}