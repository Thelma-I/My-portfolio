import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../core/theme.dart';

class MarqueeTicker extends StatelessWidget {
  const MarqueeTicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: AppTheme.borderColor(context),
            width: 1,
          ),
        ),
      ),
      child: Marquee(
        text: 'MY WORKS  ×  MY WORKS  ×  MY WORKS  ×  '
              'MY WORKS  ×  MY WORKS  ×  MY WORKS  ×  ',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 3,
          color: AppTheme.textColor(context),
        ),
        scrollAxis: Axis.horizontal,
        velocity: 60,
        blankSpace: 0,
        pauseAfterRound: Duration.zero,
        startAfter: Duration.zero,
      ),
    );
  }
}