import 'package:flutter/material.dart';

Widget goalWidget(
    index, message, currentIndex, moveLeft, moveRight, scale, onTap) {
  bool reached = false;
  if (currentIndex >= index - 1) {
    reached = true;
  }
  return SizedBox(
    height: 96,
    child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.end,
        textDirection: index.isOdd
            ? TextDirection.ltr
            : TextDirection
                .rtl, //Rearrange children left sided and right sided according to index
        children: [
          Expanded(
            child: AnimatedSlide(
              offset: Offset(index.isOdd ? moveRight : moveLeft,
                  0), //use different animation value based if the widget is R or L side
              duration: const Duration(milliseconds: 1200),
              curve: Curves.ease,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 96,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level $index',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.blueGrey),
                        ),
                        Text(message),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            child: Material(
              elevation: 4,
              shape: const CircleBorder(),
              child: GestureDetector(
                onTap: onTap,
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: reached ? Colors.yellow : Colors.white,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blueGrey[100],
                    child: const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
        ]),
  );
}
