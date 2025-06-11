import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const AuthGradientButton({super.key , required this.text , required this.onTap});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: const LinearGradient(colors: [
          Pallete.gradient1,
          Pallete.gradient2,
        ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        )
      ),
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Pallete.transparentColor,
            shadowColor: Pallete.transparentColor,
            fixedSize: const Size(395, 55),
            textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600
            ),
          ),
          child: Text(text)),
    );
  }
}
