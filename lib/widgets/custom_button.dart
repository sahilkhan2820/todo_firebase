import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialLoginButton extends StatelessWidget {
  final GestureTapCallback? onPressed;
  final String? icon;
  final String? buttonText;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final double? height;

  const SocialLoginButton(
      {Key? key,
      @required this.onPressed,
      this.icon,
      this.buttonColor,
      this.buttonText,
      this.buttonTextColor,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: height),
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              backgroundColor: MaterialStateProperty.all(buttonColor)),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(icon!, width: 30.0),
              Expanded(
                child: Center(
                  child: Text(
                    buttonText!,
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
