import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';

class MyDropdownSearch<T> extends StatelessWidget {
  final String? label;
  final String? labelText;
  final String? hintText;
  final List<T>? items;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final T? selectedItem;
  final String Function(T)? itemAsString;
  final bool showSearchBox;
  final bool clearButtonVisibility;
  final bool isRequired;

  MyDropdownSearch({
    Key? key,
    this.label,
    this.labelText,
    this.hintText,
    this.items,
    this.onChanged,
    this.validator,
    this.selectedItem,
    this.itemAsString,
    this.showSearchBox = false,
    this.clearButtonVisibility = false,
    this.isRequired = false,
  }) : super(key: key);

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
                          style: TextStyle(fontSize: 16),
                        ),
                        isRequired
                            ? Text(' *', style: TextStyle(fontSize: 16, color: Colors.red))
                            : Container(),
                      ],
                    ),
                    SizedBox(height: 8.0),
                  ],
                )
              : Container(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ButtonSizeConstants.borderRadius),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: DropdownSearch<T>(
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: labelText,
                  hintText: hintText,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                ),
              ),
              items: items ?? [],
              onChanged: onChanged,
              validator: validator,
              selectedItem: selectedItem,
              itemAsString: itemAsString,
              clearButtonProps: ClearButtonProps(
                isVisible: clearButtonVisibility,
                padding: EdgeInsets.all(0.0),
              ),
              popupProps: PopupProps.menu(
                fit: FlexFit.loose,
                menuProps: MenuProps(),
                showSearchBox: showSearchBox,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'اكتب للبحث',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}