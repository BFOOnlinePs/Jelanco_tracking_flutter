import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final void Function(List<T>)? onSelectionChange;

  // final List<T> items;

  const MyMultiSelectDropDown({
    super.key,
    // required this.options,
    this.hint,
    // required this.onOptionSelected,
    // this.selectedOptions,
    this.titleText,
    this.controller,
    required this.items,
    this.isFieldRequired = false,
    this.onSelectionChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TextFormFieldSizeConstants.padding),
      child: Column(
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
                            ? const Text(
                                ' *',
                                style: TextStyle(fontSize: 16, color: Colors.red),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(
                      height: TextFormFieldSizeConstants.sizedBoxHeight,
                    ),
                  ],
                )
              : Container(),
          MultiDropdown<T>(
            controller: controller,
            chipDecoration: ChipDecoration(
              wrap: true,
              backgroundColor: ColorsConstants.primaryColor.withOpacity(0.8),
              labelStyle: const TextStyle(color: Colors.white),
              deleteIcon: const Icon(
                Icons.clear,
                color: Colors.white,
                size: 14,
              ),
            ),
            fieldDecoration: FieldDecoration(
              backgroundColor: Colors.white,
              hintText: hint ?? '',
              padding: EdgeInsets.symmetric(vertical: 10.0.w, horizontal: 20.0.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TextFormFieldSizeConstants.borderRadius),
                borderSide: BorderSide(color: Colors.grey[700]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TextFormFieldSizeConstants.borderRadius),
                borderSide: const BorderSide(color: ColorsConstants.primaryColor),
              ),
            ),
            dropdownItemDecoration: DropdownItemDecoration(
              selectedIcon: const Icon(Icons.check_box, color: Colors.green),
              disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
            ),
            items: items,
            onSelectionChange: onSelectionChange,

            // selectedOptionTextColor: ColorsConstants.primaryColor,
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
      ),
    );
  }
}
