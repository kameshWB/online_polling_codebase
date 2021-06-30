import 'package:flutter/material.dart';
import 'package:onlinre_polling/core/constants/constants.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Center(
        child: Lottie.asset(
          AppImages.lotties.dogWalking,
          height: 300,
          width: 300,
        ),
      ),
    );
  }
}
