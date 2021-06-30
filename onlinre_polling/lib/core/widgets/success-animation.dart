import 'package:flutter/material.dart';
import 'package:onlinre_polling/core/constants/constants.dart';
import 'package:lottie/lottie.dart';

class SuccessAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Center(
        child: Lottie.asset(
          AppImages.lotties.success,
          height: 300,
          width: 300,
          repeat: false,
        ),
      ),
    );
  }
}
