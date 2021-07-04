// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:onlinre_polling/core/constants/constants.dart';
// import 'package:onlinre_polling/core/schemas/user-schemas.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class EventListItem extends StatelessWidget {
//   final int id;
//   final String title;
//   final String date;
//   final int status;
//   final int priority;
//   final bool isClosed;
//
//   EventListItem({
//     this.title,
//     this.date,
//     this.status = 0,
//     this.priority = 0,
//     this.isClosed = false,
//     this.id,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(
//           left: 50,
//           right: 50,
//           bottom: 20,
//           top: 20,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 if (isClosed)
//                   Container(
//                     height: 20,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(8),
//                       ),
//                       color: Colors.redAccent,
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Closed',
//                         style: GoogleFonts.mulish(
//                           color: AppColor.text.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                     ),
//                   )
//                 else
//                   Container(
//                     height: 20,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(8),
//                       ),
//                       color: Colors.green,
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Open',
//                         style: GoogleFonts.mulish(
//                           color: AppColor.text.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                     ),
//                   ),
//                 if (!isAdmin)
//                   if (status == 1)
//                     Container(
//                       height: 20,
//                       width: 20,
//                       margin: EdgeInsets.only(right: 20),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: AppColor.text.grey,
//                           width: 2,
//                         ),
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.check,
//                           color: AppColor.white,
//                           size: 15,
//                         ),
//                       ),
//                     )
//                   else if (status == 2)
//                     Container(
//                       height: 20,
//                       width: 20,
//                       margin: EdgeInsets.only(right: 20),
//                       decoration: BoxDecoration(
//                         color: AppColor.border.blue,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.check,
//                           color: AppColor.white,
//                           size: 15,
//                         ),
//                       ),
//                     )
//                   else
//                     Container(
//                       height: 20,
//                       width: 20,
//                     ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20.0),
//                   child: Text(
//                     title,
//                     textAlign: TextAlign.left,
//                     style: GoogleFonts.mulish(
//                         color: Color.fromRGBO(37, 39, 51, 1),
//                         fontSize: 14,
//                         letterSpacing: 0.20000000298023224,
//                         fontWeight: FontWeight.normal,
//                         height: 1.4285714285714286),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 if (priority == 3)
//                   Container(
//                     height: 20,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(8),
//                       ),
//                       color: Colors.redAccent,
//                     ),
//                     child: Center(
//                       child: Text(
//                         'HIGH',
//                         style: GoogleFonts.mulish(
//                           color: AppColor.text.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                     ),
//                   )
//                 else if (priority == 2)
//                   Container(
//                     height: 20,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(8),
//                       ),
//                       color: Colors.orangeAccent,
//                     ),
//                     child: Center(
//                       child: Text(
//                         'MEDIUM',
//                         style: GoogleFonts.mulish(
//                           color: AppColor.text.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                     ),
//                   )
//                 else if (priority == 1)
//                   Container(
//                     height: 20,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(8),
//                       ),
//                       color: Colors.green,
//                     ),
//                     child: Center(
//                       child: Text(
//                         'LOW',
//                         style: GoogleFonts.mulish(
//                           color: AppColor.text.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                     ),
//                   ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Text(
//                   date,
//                   textAlign: TextAlign.left,
//                   style: GoogleFonts.mulish(
//                       color: AppColor.text.darkRed,
//                       fontSize: 14,
//                       letterSpacing: 0.20000000298023224,
//                       fontWeight: FontWeight.normal,
//                       height: 1.4285714285714286),
//                 ),
//                 if (isAdmin)
//                   DropdownButton(
//                     icon: Icon(Icons.more_vert),
//                     underline: Container(
//                       width: 10,
//                     ),
//                     items: <String>[
//                       'Open',
//                       'Close',
//                       'Delete',
//                     ].map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                         onTap: () {},
//                       );
//                     }).toList(),
//                     onTap: () {
//                       print('Tapped');
//                     },
//                     onChanged: (value) {
//                       print(value);
//                       if (value == 'Open') {
//                         DataSchemas.events.doc(id.toString()).set({
//                           'isClosed': false,
//                         }, SetOptions(merge: true));
//                       } else if (value == 'Close') {
//                         ///update db to close
//                         DataSchemas.events.doc(id.toString()).set({
//                           'isClosed': true,
//                         }, SetOptions(merge: true));
//                       } else if (value == 'Delete') {
//                         DataSchemas.events.doc(id.toString()).delete();
//                       }
//                     },
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
