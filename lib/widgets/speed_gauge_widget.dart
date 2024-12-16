import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedGaugeWidget extends StatelessWidget {
  const SpeedGaugeWidget({
    super.key,
    required this.value,
    required this.unit,
    required this.pointerColor,
    this.enableLoadingAnimation = true,
  });

  final double value;
  final String unit;
  final Color pointerColor;
  final bool enableLoadingAnimation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      height: 300.0,
      child: SfRadialGauge(
        enableLoadingAnimation: enableLoadingAnimation,
        animationDuration: 4500,
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 100,
            ranges: [
              GaugeRange(
                startValue: 0,
                endValue: 100,
                startWidth: 10,
                endWidth: 10,
                color: Colors.black12,
              ),
            ],
            pointers: [
              NeedlePointer(
                value: value,
                enableAnimation: true,
              ),
              RangePointer(
                value: value,
                enableAnimation: true,
                color: pointerColor,
              ),
            ],
            annotations: [
              GaugeAnnotation(
                widget: Padding(
                  padding: const EdgeInsets.only(
                    top: 220,
                  ),
                  child: Text(
                    '$value $unit',
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
