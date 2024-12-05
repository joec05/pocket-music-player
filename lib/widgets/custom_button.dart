import 'package:flutter/material.dart';
import 'package:pocket_music_player/global_files.dart';

Color defaultCustomButtonColor = Colors.blueGrey.withOpacity(0.6);

class CustomButton extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final String text;
  final Widget? prefix;
  final VoidCallback? onTapped;
  final bool setBorderRadius;
  final bool loading;

  const CustomButton({
    super.key, 
    required this.width, 
    required this.height, 
    required this.color, 
    required this.text,
    required this.prefix,
    required this.onTapped, 
    required this.setBorderRadius,
    required this.loading
  });

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  @override void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width, height: widget.height,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.onTapped == null ? const Color.fromARGB(255, 112, 104, 104).withOpacity(0.5) : widget.color,
          borderRadius: widget.setBorderRadius ? const BorderRadius.all(Radius.circular(5)) : BorderRadius.zero
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashFactory: InkSparkle.splashFactory,
            onTap: (){
              Future.delayed(
                const Duration(milliseconds: 150), 
                (){}
              ).then((value) => widget.onTapped!());
            },
            child: Center(
              child: widget.loading ? 
                SizedBox(
                  width: widget.height * 0.45,
                  height: widget.height * 0.45,
                  child: const CircularProgressIndicator(
                    color: Colors.cyan,
                    strokeWidth: 2.5,
                  )
                )
              :
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.prefix != null ?
                      Row(
                        children: [
                          widget.prefix!,
                          SizedBox(
                            width: getScreenWidth() * 0.035
                          )
                        ]
                      )
                    : Container(),
                    Text(
                      widget.text, 
                      style: const TextStyle(
                        fontWeight: FontWeight.w500, 
                        fontSize: 15
                      )
                    ),
                  ],
                )
            )
          ),
        ),
      )
    );
  }

}