// import 'package:flutter/material.dart';
//
// class CustomRadioButton extends StatefulWidget {
//   final String title;
//   final List<String> options;
//   final Function(String) onChanged;
//
//   CustomRadioButton({required this.title, required this.options, required this.onChanged});
//
//   @override
//   _CustomRadioButtonState createState() => _CustomRadioButtonState();
// }
//
// class _CustomRadioButtonState extends State<CustomRadioButton> {
//   late String _selectedOption;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedOption = widget.options.first;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 8.0),
//           child: Text(
//             widget.title,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16.0,
//             ),
//           ),
//         ),
//         Column(
//           children: widget.options.map((option) {
//             return ListTile(
//               title: Text(option),
//               leading: Radio(
//                 value: option,
//                 groupValue: _selectedOption,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedOption = value.toString();
//                   });
//                   widget.onChanged(value.toString());
//                 },
//               ),
//               onTap: () {
//                 setState(() {
//                   _selectedOption = option;
//                 });
//                 widget.onChanged(option);
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
