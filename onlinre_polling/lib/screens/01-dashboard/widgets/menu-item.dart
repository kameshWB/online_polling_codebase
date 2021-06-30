import 'package:flutter/material.dart';
import 'package:onlinre_polling/core/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;
  bool isSelected;

  MenuItem(
      {@required this.text,
      @required this.icon,
      this.isSelected = false,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        color: isSelected ? Colors.white10 : Colors.transparent,
        child: Row(
          children: [
            if (isSelected)
              Container(
                width: 5,
                height: 50,
                color: AppColor.white,
              ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(
                icon,
                size: 20,
                color: Color.fromRGBO(164, 166, 179, 1),
              ),
            ),
            Text(
              text,
              style: GoogleFonts.mulish(
                textStyle: TextStyle(
                  color: AppColor.text.grey,
                  fontSize: 14,
                  letterSpacing: 0.4000000059604645,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
