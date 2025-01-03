import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/core/constants/text_form_field_size.dart';

class MyDropdownButton<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<T> items;
  final String Function(T) displayText;

  // final int Function(T) unique;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final bool isRequired;
  final AlignmentGeometry alignmentGeometry;
  final double? menuMaxHeight;
  final bool isFieldRequired;

  const MyDropdownButton(
      {super.key,
      this.label,
      this.hint,
      required this.value,
      required this.items,
      required this.displayText,
      // required this.unique,
      required this.onChanged,
      this.validator,
      this.isRequired = false,
      this.alignmentGeometry = AlignmentDirectional.centerStart,
      this.menuMaxHeight,
      this.isFieldRequired = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label != null
              ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          label!,
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
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ButtonSizeConstants.borderRadius),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField<T>(
                  value: value,
                  hint: hint != null ? Text(hint!) : null,
                  items: items.map((item) {
                    return DropdownMenuItem<T>(
                      alignment: alignmentGeometry,
                      value: item,
                      child: Text(displayText(item)),
                    );
                  }).toList(),
                  onChanged: onChanged,
                  validator: validator,
                  isExpanded: true,
                  // underline: Container(), // to remove the line

                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  menuMaxHeight: menuMaxHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
