import 'package:flutter/material.dart';

const String diveDateDateFormat = 'Roboto';

bool isAdmin;

class AppFonts {
  static const String roboto = 'Roboto';
  static const String monteserrat = 'Monteserrat';
}

class AppColor {
  static _TextColorConstants text = const _TextColorConstants();
  static _BackgroundColorConstants background =
      const _BackgroundColorConstants();
  static _BorderColorConstants border = const _BorderColorConstants();
  static _DarkModeColorConstants dark = const _DarkModeColorConstants();
  static const Color white = Colors.white;
  static const Color blue = const Color(0xff2196F3);
}

class _TextColorConstants {
  const _TextColorConstants();
  Color get white => Colors.white;
  Color get validationFailureGrey => const Color(0xffd8d8d8);
  Color get validationSuccessGrey => const Color(0xff333333);
  Color get grey => const Color.fromRGBO(164, 166, 179, 1);
  Color get darkGrey => const Color(0xff5e5e5e);
  Color get black => Colors.black;
  Color get blue => const Color(0xff2196F3);
  Color get red => const Color(0xfff52323);
  Color get darkRed => const Color(0xffab0800);
  Color get extraDarkGrey => const Color.fromARGB(255, 33, 33, 33);
}

class _BackgroundColorConstants {
  const _BackgroundColorConstants();

  Color get white => Colors.white;
  Color get grey => Color(0xff9e9e9e);
  Color get lightGrey => Color(0xfff5f5f5);
  Color get black => Colors.black;
  Color get blue => Color(0xff2196F3);
  Color get facebookBlue => Color.fromRGBO(66, 103, 178, 1);
  Color get googleBlue => Color(0xff4285f4);
  Color get blueGrey => Color(0xffE5E5E5);
  Color get lightBlue => Color(0xffF7F8FC);
  Color get blueGreen => Color.fromRGBO(100, 252, 217, 1);
  Color get darkGrey => Color(0xff363740);
}

class _DarkModeColorConstants {
  const _DarkModeColorConstants();
  Color get canvasBlue => Color(0xff282833);
  Color get primaryBlue => Color(0xff147AD6);
}

class _BorderColorConstants {
  const _BorderColorConstants();
  Color get black => Colors.black;
  Color get blue => Color.fromRGBO(55, 81, 255, 1);
  Color get darkRed => Color(0xffab0800);
}

class AppFont {
  static String font = 'Monteserrat';
}

class FontSize {
  static double title = 21;
  static double textSize = 16;
  static double small = 12;
}

class RegularExpressions {
  static RegExp emailRegEx = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp passwordRegEx = RegExp(
      r"^(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[a-zA-Z!#₹$@^%&? ])[a-zA-Z0-9!#₹$@^%&?]{8,}$");
}

class AppImages {
  static _BackgroundImages background = const _BackgroundImages();
  static _IllustrationImages illustrations = const _IllustrationImages();
  static _BadgeImages badges = const _BadgeImages();
  static _Logos logos = const _Logos();
  static _Icons icons = const _Icons();
  static _Lotties lotties = const _Lotties();
  static const String profileAvatar = 'images/dummyAvatars/IMG_0267.jpg';

  static const List<String> galleryList = [
    'images/galleryImages/IMG_0331.jpg',
    'images/galleryImages/IMG_0985.jpg',
    'images/galleryImages/IMG_1023.jpg',
    'images/galleryImages/IMG_1033.jpg',
    'images/galleryImages/IMG_1052.jpg',
    'images/galleryImages/IMG_1057.jpg',
    'images/galleryImages/IMG_1064-2.jpg',
    'images/galleryImages/IMG_1115.jpg',
    'images/galleryImages/IMG_1178.jpg',
    'images/galleryImages/IMG_1182.jpg',
    'images/galleryImages/IMG_1242.jpg',
    'images/galleryImages/IMG_1301.jpg',
    'images/galleryImages/IMG_1313.jpg',
    'images/galleryImages/IMG_1572.jpg',
    'images/galleryImages/IMG_2167.jpg',
  ];

  static const List<String> splashImages = [
    'images/backgroundImages/splash1/1.png',
    'images/backgroundImages/splash1/2.png',
    'images/backgroundImages/splash1/3.png',
    'images/backgroundImages/splash1/4.png',
    'images/backgroundImages/splash1/5.png',
    'images/backgroundImages/splash1/6.png',
    'images/backgroundImages/splash1/8.png',
    'images/backgroundImages/splash1/9.png',
    'images/backgroundImages/splash1/10.png',
    'images/backgroundImages/splash1/11.png',
    'images/backgroundImages/splash1/12.png',
  ];
}

class _BackgroundImages {
  const _BackgroundImages();
  String get homePatterns => 'assets/svgs/backgrounds/background.svg';
}

class _IllustrationImages {
  const _IllustrationImages();
  String get boySearch => 'assets/svgs/illustrations/search-boy.svg';
}

class _Logos {
  const _Logos();
  String get googleG => 'images/logos/google-g.jpg';
  String get diversAlert => 'images/logos/divers-alert.png';
  String get diversDashBoardLogo => 'images/logos/diver_dash_logo.png';
  String get diversDashBoard => 'images/logos/diver_dash.png';
  String get diveAssure => 'images/logos/dive-assure.jpeg';
}

class _Lotties {
  const _Lotties();
  String get dogWalking => 'assets/lotties/65014-dog-walking.json';
  String get success => 'assets/lotties/51478-success.json';
}

class _Icons {
  const _Icons();
  String get menu => 'images/icons/menu.png';
  String get upload => 'images/icons/upload.png';
  String get diver => 'images/icons/diver.png';
}

class _BadgeImages {
  const _BadgeImages();
  String get amphibians => 'images/badges/Amphiabians.png';
  String get birthdaySuit => 'images/badges/Birthday Suit.png';
  String get challengeDestroyer => 'images/badges/Challenge Destroyer.png';
  String get chameleon => 'images/badges/Chameleon.png';
  String get divePartner => 'images/badges/Dive Partner.png';
  String get diveAddict => 'images/badges/Diveaddict.png';
  String get diveHolic => 'images/badges/DiveHolic.png';
  String get gearGuru => 'images/badges/Gear Guru.png';
  String get guide => 'images/badges/Guide.png';
  String get highIntensity => 'images/badges/High Intensity.png';
  String get masterPhotographer => 'images/badges/Master Photographer.png';
  String get millionaire => 'images/badges/Millionaire.png';
  String get millionaireBubbles => 'images/badges/Millionaire - Bubbles.png';
  String get networkDiver => 'images/badges/Network Diver.png';
  String get photographerNewB => 'images/badges/Photographer NewB.png';
  String get photographerPro => 'images/badges/Photographer Pro.png';
  String get treasureHunter => 'images/badges/Treasure Hunter.png';
  String get tribalChief => 'images/badges/Tribal Chief.png';
  String get virtualDiver => 'images/badges/Virtual Diver.png';
  String get virtualOWD => 'images/badges/Virtual OWD.png';
}

class AppStyles {
  static _InputDecorations inputDecorations = const _InputDecorations();
}

class _InputDecorations {
  const _InputDecorations();
  InputDecoration formInputDecoration({
    @required String hintText,
    @required String errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColor.text.grey,
        fontSize: FontSize.textSize,
        fontWeight: FontWeight.w100,
      ),
      fillColor: AppColor.background.lightGrey,
      filled: true,
      errorText: errorText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColor.border.blue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColor.border.blue,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColor.border.darkRed,
          width: 2,
        ),
      ),
    );
  }
}
