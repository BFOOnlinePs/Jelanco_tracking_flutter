// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pal_cars/constants/button_size.dart';
//
// class MyDropdownSearch<T> extends StatelessWidget {
//   final String? label;
//   final String? labelText;
//   final String? hintText;
//   final List<T>? items;
//   final Function(T?)? onChanged;
//   final String? Function(T?)? validator;
//   final T? selectedItem;
//   final String Function(T)? itemAsString;
//   final bool showSearchBox;
//   final bool clearButtonVisibility;
//   final bool isRequired;
//
//   MyDropdownSearch({
//     Key? key,
//     this.label,
//     this.labelText,
//     this.hintText,
//     this.items,
//     this.onChanged,
//     this.validator,
//     this.selectedItem,
//     this.itemAsString,
//     this.showSearchBox = false,
//     this.clearButtonVisibility = false,
//     this.isRequired = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 7.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           label != null
//               ? Column(
//             children: [
//               Row(
//                 children: [
//                   Text(label ?? '', style: TextStyle(fontSize: 16)),
//                   isRequired
//                       ? Text(' *',
//                       style:
//                       TextStyle(fontSize: 16, color: Colors.red))
//                       : Container(),
//                 ],
//               ),
//               SizedBox(height: 8.0)
//             ],
//           )
//               : Container(),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12.0),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(ButtonSizeConstants.borderRadius),
//               border: Border.all(
//                 color: Colors.grey,
//                 width: 1.0,
//               ),
//             ),
//             child: DropdownSearch<T>(
//               dropdownDecoratorProps: DropDownDecoratorProps(
//                 dropdownSearchDecoration: InputDecoration(
//                   labelText: labelText,
//                   hintText: hintText,
//                   border: InputBorder.none,
//                 ),
//               ),
//               items: items ?? [],
//               onChanged: onChanged,
//
//               validator: validator,
//               selectedItem: selectedItem,
//               itemAsString: itemAsString,
//               clearButtonProps: ClearButtonProps(
//                 // alignment: Alignment.centerLeft,
//                 padding: EdgeInsets.all(0.0),
//                 // splashRadius: 4,
//                 isVisible: clearButtonVisibility,
//                 // icon: Icon(Icons.clear),
//               ),
//               popupProps: PopupProps.menu(
//                   fit: FlexFit.loose,
//                   menuProps: MenuProps(),
//                   searchDelay: const Duration(seconds: 0),
//                   // since it is not online search
//                   showSearchBox: showSearchBox,
//                   searchFieldProps: TextFieldProps(
//                     decoration: InputDecoration(
//                       hintText: 'اكتب للبحث',
//                     ),
//                   )),
//
//               // for online Dio search
//               // asyncItems: ,
//               //   onSaved: (String filter) => searchFunction(filter),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
