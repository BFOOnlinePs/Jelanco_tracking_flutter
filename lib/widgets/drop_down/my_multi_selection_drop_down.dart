// import 'package:flutter/material.dart';
// import 'package:multi_dropdown/multiselect_dropdown.dart';
// import 'package:pal_cars/constants/colors.dart';
// import 'package:pal_cars/constants/text_form_field_size.dart';
//
// class MyMultiSelectDropDown<T> extends StatelessWidget {
//   final List<ValueItem<T?>> options;
//   final List<ValueItem<T?>>? selectedOptions;
//   final String? hint;
//   final Function(List<ValueItem<T?>>)? onOptionSelected;
//   final MultiSelectController<T?>? controller;
//   final String? titleText;
//   final bool isFieldRequired;
//
//   const MyMultiSelectDropDown({
//     Key? key,
//     required this.options,
//     this.hint,
//     required this.onOptionSelected,
//     this.selectedOptions,
//     this.titleText,
//     this.controller,
//     this.isFieldRequired = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         titleText != null
//             ? Column(
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         titleText!,
//                         style: const TextStyle(
//                             fontSize: TextFormFieldSizeConstants.titleSize),
//                       ),
//                       isFieldRequired
//                           ? Text(
//                               ' *',
//                               style: TextStyle(fontSize: 16, color: Colors.red),
//                             )
//                           : Container(),
//                     ],
//                   ),
//                   SizedBox(
//                     height: TextFormFieldSizeConstants.sizedBoxHeight,
//                   ),
//                 ],
//               )
//             : Container(),
//         MultiSelectDropDown<T?>(
//           controller: controller,
//           chipConfig: ChipConfig(
//             wrapType: WrapType.wrap,
//             backgroundColor: ColorsConstants.primaryColor,
//           ),
//           dropdownHeight: options.length * 50 > 300 ? 300 : options.length * 50,
//           hint: hint ?? '',
//           hintColor: Colors.black,
//           selectedOptionTextColor: ColorsConstants.primaryColor,
//           borderRadius: TextFormFieldSizeConstants.borderRadius,
//           borderColor: Colors.grey[900]!,
//           fieldBackgroundColor: Colors.grey[200]!,
//           onOptionSelected: onOptionSelected,
//           selectedOptions: selectedOptions ?? [],
//           options: options,
//           optionSeparator: Container(
//             height: 1,
//             color: Colors.grey,
//           ),
//           // selectedItemBuilder: (p0, p1) => ,
//         ),
//       ],
//     );
//   }
// }
