import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pocket_music_player/global_files.dart';

class SoundwaveWidget extends StatefulWidget {
  const SoundwaveWidget({
    super.key
  });
  @override
  State<SoundwaveWidget> createState() => _SoundwaveWidgetState();
}

class _SoundwaveWidgetState extends State<SoundwaveWidget> with TickerProviderStateMixin {
  final AnimationController controller = appStateRepo.soundwaveAnimationController!;
  final int count = 3;
  final double minHeight = getScreenWidth() * 0.05;
  final double maxHeight = getScreenWidth() * 0.1;
  final int durationInMilliseconds = 500;
  List<MaterialAccentColor> waveColors = List.generate(3, (i) => Colors.accents[Random().nextInt(Colors.accents.length)]);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (c, child) {
        double t = controller.value;
        int current = (count * t).floor();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            count,
            (i) => AnimatedContainer(
              duration: Duration(
                  milliseconds: durationInMilliseconds ~/ count),
              margin: i == (count - 1)
                  ? EdgeInsets.zero
                  : EdgeInsets.only(right: getScreenWidth() * 0.01),
              height: i == current ? maxHeight : minHeight,
              width: getScreenWidth() * 0.018,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: waveColors[i]
              ),
            ),
          ),
        );
      },
    );
  }
}