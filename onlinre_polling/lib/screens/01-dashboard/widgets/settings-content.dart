// import 'package:flutter/material.dart';
// import 'package:onlinre_polling/core/authentication/firebase_auth.dart';
// import 'package:onlinre_polling/core/widgets/web-bar.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:onlinre_polling/screens/00-home/home.dart';
//
// class SettingsContent extends StatelessWidget {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController conformPasswordController =
//       TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         WebBar(
//           title: 'Settings',
//         ),
//         Column(
//           children: [
//             ///Name
//             Container(
//               width: 300,
//               padding: EdgeInsets.only(top: 50),
//               child: TextField(
//                 style: GoogleFonts.poppins(
//                   textStyle: TextStyle(
//                     color: Colors.black,
//                   ),
//                 ),
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   hintText: 'Name',
//                   hintStyle: GoogleFonts.poppins(
//                     textStyle: TextStyle(
//                       color: Colors.black,
//                     ),
//                   ),
//                   disabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black87),
//                   ),
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                   border: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                 ),
//               ),
//             ),
//
//             ///Password
//             Container(
//               width: 300,
//               padding: EdgeInsets.only(top: 50),
//               child: TextField(
//                 style: GoogleFonts.poppins(
//                   textStyle: TextStyle(
//                     color: Colors.black,
//                   ),
//                 ),
//                 obscureText: true,
//                 obscuringCharacter: '*',
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   hintText: 'Password',
//                   hintStyle: GoogleFonts.poppins(
//                     textStyle: TextStyle(
//                       color: Colors.black,
//                     ),
//                   ),
//                   disabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black87),
//                   ),
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                   border: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                 ),
//               ),
//             ),
//
//             ///Confirm Password
//             Container(
//               width: 300,
//               padding: EdgeInsets.only(top: 50),
//               child: TextField(
//                 style: GoogleFonts.poppins(
//                   textStyle: TextStyle(
//                     color: Colors.black,
//                   ),
//                 ),
//                 obscureText: true,
//                 obscuringCharacter: '*',
//                 controller: conformPasswordController,
//                 decoration: InputDecoration(
//                   hintText: 'Confirm Password',
//                   hintStyle: GoogleFonts.poppins(
//                     textStyle: TextStyle(
//                       color: Colors.black,
//                     ),
//                   ),
//                   disabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black87),
//                   ),
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                   border: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Colors.black),
//                   ),
//                 ),
//               ),
//             ),
//
//             ///Update
//             Center(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   top: 100,
//                   bottom: 5,
//                   left: 30,
//                   right: 30,
//                 ),
//                 child: CustomButton(
//                   text: 'Update',
//                   onTap: () {
//                     print('update');
//                     updateNameAndPassword();
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
// }
