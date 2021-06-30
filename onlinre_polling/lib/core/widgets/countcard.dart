import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinre_polling/core/constants/constants.dart';

class CountCards extends StatelessWidget {
  final String count;
  final String title;
  final bool selected;
  final Function onTap;

  CountCards({this.count, this.title, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 250,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(
            color: selected
                ? AppColor.border.blue
                : Color.fromRGBO(223, 224, 235, 1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.mulish(
                  color: selected
                      ? AppColor.border.blue
                      : Color.fromRGBO(159, 162, 180, 1),
                  fontSize: 19,
                  letterSpacing: 0.4000000059604645,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              count,
              textAlign: TextAlign.center,
              style: GoogleFonts.mulish(
                  color: selected
                      ? AppColor.border.blue
                      : Color.fromRGBO(37, 39, 51, 1),
                  fontSize: 40,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ],
        ),
      ),
    );
  }
}
