// import 'package:flutter/material.dart';
//
// void  showPopupMenu(BuildContext context) {
//   showMenu(
//     context: context,
//     position: RelativeRect.fromLTRB(100, 100, 100, 100),
//     items: [
//       PopupMenuItem(
//         value: 'image',
//         child: ListTile(
//           leading: Icon(Icons.image),
//           title: Text('Pick Image'),
//         ),
//       ),
//       PopupMenuItem(
//         value: 'video',
//         child: ListTile(
//           leading: Icon(Icons.videocam),
//           title: Text('Pick Video'),
//         ),
//       ),
//     ],
//   ).then((value) {
//     // if (value == 'image') {
//     //   _pickMedia(context, isVideo: false);
//     // } else if (value == 'video') {
//     //   _pickMedia(context, isVideo: true);
//     // }
//   });
// }