import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/theme.dart';

// class MyBtnSelectorExperience extends StatefulWidget {
//   MyBtnSelectorExperience({Key? key,
//   // @required this.controller,
//   required this.hint,
//   required this.title,
//   required this.callback,
//   }) : super(key: key);
//   final String? title ;
//   final String? hint ;
//   final Function() callback;
//
//   @override
//   State<MyBtnSelectorExperience> createState() => _MyBtnSelectorExperienceState();
// }
//
// class _MyBtnSelectorExperienceState extends State<MyBtnSelectorExperience> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0 , left: 8.0),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0 , left: 8.0),
//             child: Align(
//                 alignment: Alignment.topLeft,
//                 child: Text("${widget.title}", style: ourTextStyle())),
//           ),
//           SizedBox(height: size_H(10),),
//           InkWell(
//             onTap: (){
//               widget.callback();
//             },
//             child: Container(
//               height: size_H(50),
//               // decoration: BoxDecoration(
//               //   color: Theme_Information.Color_9,
//               //   borderRadius: BorderRadius.circular(15.0),
//               // ),
//               child: Center(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Theme_Information.Color_9,
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           padding: const EdgeInsets.only(right: 15 , left: 15),
//                           underline: Container(),
//                           value: 'Year',
//                           onChanged: (String? newValue) {
//                             // Handle the selection
//                             print(newValue);
//                           },
//                           items: <String>['Year', 'Month']
//                               .map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(width: size_W(20),),
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Theme_Information.Color_9,
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           padding: const EdgeInsets.only(right: 15 , left: 15),
//                           underline: Container(),
//                           value: 'Year',
//                           onChanged: (String? newValue) {
//                             // Handle the selection
//                             print(newValue);
//                           },
//                           items: <String>['Year', 'Month']
//                               .map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//
//
//
//                          ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
