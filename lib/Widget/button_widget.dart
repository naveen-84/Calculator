import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color; // 🔥 Accept custom color

  const ButtonWidget({
    required this.text,
    required this.onTap,
    this.color = Colors.white, // Default color is white
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[850], // Dark grey background
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color, // 🔥 Apply custom color
            ),
          ),
        ),
      ),
    );
  }
}
