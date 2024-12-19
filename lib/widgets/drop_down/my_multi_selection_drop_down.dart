import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/core/constants/text_form_field_size.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MyMultiSelectDropDown<T extends Object> extends StatelessWidget {
  // final List<ValueItem<T?>> options;
  // final List<ValueItem<T?>>? selectedOptions;
  final String? hint;

  // final Function(List<ValueItem<T?>>)? onOptionSelected;
  final MultiSelectController<T>? controller;
  final String? titleText;
  final bool isFieldRequired;

  final List<DropdownItem<T>> items;
  // final List<T> items;

  const MyMultiSelectDropDown({
    Key? key,
    // required this.options,
    this.hint,
    // required this.onOptionSelected,
    // this.selectedOptions,
    this.titleText,
    this.controller,
    required this.items,
    this.isFieldRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titleText != null
            ? Column(
                children: [
                  Row(
                    children: [
                      Text(
                        titleText!,
                        style: TextStyle(fontSize: SharedSize.textFiledTitleSize),
                      ),
                      isFieldRequired
                          ? Text(
                              ' *',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: TextFormFieldSizeConstants.sizedBoxHeight,
                  ),
                ],
              )
            : Container(),
        MultiDropdown<T>(
          controller: controller,
          chipDecoration: ChipDecoration(
            wrap: true,
            backgroundColor: ColorsConstants.primaryColor,
          ),
          // items: items
          //     .map((e) => DropdownItem(
          //           value: e,
          //           label: itemLabel,
          //         ))
          //     .toList(),
          items: items,
          // dropdownHeight: options.length * 50 > 300 ? 300 : options.length * 50,
          //
          // hint: hint ?? '',
          // hintColor: Colors.black,
          // selectedOptionTextColor: ColorsConstants.primaryColor,
          // borderRadius: TextFormFieldSizeConstants.borderRadius,
          // borderColor: Colors.grey[900]!,
          // fieldBackgroundColor: Colors.grey[200]!,
          // onOptionSelected: onOptionSelected,
          // selectedOptions: selectedOptions ?? [],
          // options: options,
          // optionSeparator: Container(
          //   height: 1,
          //   color: Colors.grey,
          // ),
          // selectedItemBuilder: (p0, p1) => ,
        ),
      ],
    );
  }
}
