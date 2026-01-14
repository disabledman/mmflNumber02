import 'package:flutter/material.dart';

class CarryingHint extends StatelessWidget {
  final int carryOver;

  const CarryingHint({
    super.key,
    required this.carryOver,
  });

  @override
  Widget build(BuildContext context) {
    if (carryOver == 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 40), // + 號位置
          const SizedBox(width: 10),
          Container(
            width: 50,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.orange.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.orange.shade600,
                width: 2,
              ),
            ),
            child: Text(
              carryOver.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const SizedBox(width: 50), // 對齊個位數位置
        ],
      ),
    );
  }
}
