import 'package:flutter/material.dart';
import 'package:music_player_app/global_files.dart';

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
  final double minHeight = 7.5;
  final double maxHeight = 25;
  final int durationInMilliseconds = 500;

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
                  : const EdgeInsets.only(right: 5),
              height: i == current ? maxHeight : minHeight,
              width: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
        );
      },
    );
  }
}