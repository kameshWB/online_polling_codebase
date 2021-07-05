import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinre_polling/core/authentication/firebase_auth.dart';
import 'package:onlinre_polling/core/constants/constants.dart';

// class buildWebBar extends StatelessWidget {
//   final String title;
//
//   buildWebBar({this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             textAlign: TextAlign.left,
//             style: GoogleFonts.mulish(
//                 color: Color.fromRGBO(37, 39, 51, 1),
//                 fontSize: 24,
//                 letterSpacing: 0.30000001192092896,
//                 fontWeight: FontWeight.bold,
//                 height: 1),
//           ),
//           Row(
//             children: [
//               //   IconButton(
//               //   icon: Icon(
//               //     Icons.notifications,
//               //   ),
//               //   onPressed: () {},
//               //   color: AppColor.text.grey,
//               // ),
//               // Container(
//               //   height: 30,
//               //   width: 1,
//               //   margin: EdgeInsets.symmetric(horizontal: 20),
//               //   color: AppColor.text.grey.withOpacity(0.3),
//               // ),
//               Text(
//                 FirebaseAuthentication.getUser().displayName ??
//                     FirebaseAuthentication.getUser().email,
//                 textAlign: TextAlign.right,
//                 style: GoogleFonts.mulish(
//                     color: AppColor.text.black,
//                     fontSize: 14,
//                     letterSpacing: 0.20000000298023224,
//                     fontWeight: FontWeight.bold,
//                     height: 1.4285714285714286),
//               ),
//               InkWell(
//                 onTap: () {},
//                 child: Container(
//                   width: 44,
//                   height: 44,
//                   margin: EdgeInsets.symmetric(horizontal: 20),
//                   decoration: BoxDecoration(
//                     color: AppColor.white,
//                     border: Border.all(
//                       color: Color.fromRGBO(223, 224, 235, 1),
//                       width: 1.5,
//                     ),
//                     borderRadius: BorderRadius.all(
//                       Radius.elliptical(44, 44),
//                     ),
//                   ),
//                   child: Center(
//                     child: Text(
//                       (FirebaseAuthentication.getUser().displayName ??
//                               FirebaseAuthentication.getUser().email ??
//                               'U')[0]
//                           .toString()
//                           .toUpperCase(),
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: AppColor.blue,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


