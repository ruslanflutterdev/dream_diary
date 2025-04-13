import 'package:flutter/material.dart';

class SleepQualitySelector extends StatelessWidget {
  final int currentQuality;
  final ValueChanged<int> onQualityChanged;

  const SleepQualitySelector({
    super.key,
    required this.currentQuality,
    required this.onQualityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final quality = index + 1;
        return ElevatedButton(
          onPressed: () => onQualityChanged(quality),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                quality <= currentQuality
                    ? Colors.amber
                    : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          child: Text(
            '$quality',
            style: TextStyle(
              color: quality <= currentQuality ? Colors.white : Colors.black,
              fontSize: 18,
            ),
          ),
        );
      }),
    );
  }
}
