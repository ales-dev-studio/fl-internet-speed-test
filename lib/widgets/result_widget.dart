import 'package:flutter/material.dart';
import 'package:speed_test/widgets/space_widget.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    super.key,
    required this.downloadRate,
    required this.uploadRate,
    required this.unit,
  });

  final double downloadRate;
  final double uploadRate;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SpaceWidget(),
        const Text(
          'Result',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        const SpaceWidget(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_circle_down_rounded,
                      color: Colors.cyanAccent,
                    ),
                    const SizedBox(width: 8.0),
                    Text('DOWNLOAD $unit'),
                  ],
                ),
                const SpaceWidget(),
                Text(
                  downloadRate == 0 ? '...' : downloadRate.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 60.0,
              child: VerticalDivider(),
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_circle_up_rounded,
                      color: Colors.purpleAccent,
                    ),
                    const SizedBox(width: 8.0),
                    Text('UPLOAD $unit'),
                  ],
                ),
                const SpaceWidget(),
                Text(
                  uploadRate == 0 ? '...' : uploadRate.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
