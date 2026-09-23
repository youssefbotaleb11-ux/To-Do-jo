import 'package:flutter/material.dart';

class ChooseColorWidget extends StatefulWidget {
  const ChooseColorWidget({super.key});

  @override
  State<ChooseColorWidget> createState() => _ChooseColorWidgetState();
}

class _ChooseColorWidgetState extends State<ChooseColorWidget> {
  List<int> colorsHex = [
    0xFF2196F3, // أزرق
    0xFF4CAF50, // أخضر
    0xFFFF9800, // برتقالي
    0xFF9C27B0, // بنفسجي
    0xFFF44336, // أحمر
    0xFF009688, // تيل / تركواز
  ];

  int selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(colorsHex.length, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedColorIndex = index;
            });
          },
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Color(colorsHex[index]),
              shape: BoxShape.circle,
              border: selectedColorIndex == index
                  ? Border.all(color: Colors.black, width: 2)
                  : null,
            ),
          ),
        );
      }),
    );
  }
}