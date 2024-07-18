import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/core/constants/text_form_field_size.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? labelText;
  final String? titleText;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool autofocus;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final bool enabled;
  final int maxLines;
  final Function(String)? onChanged;
  final bool isFieldRequired;
  final Widget? suffixIcon;
  final Function()? onTap;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? prefixIcon;
  final TextStyle? style;

  MyTextFormField({
    this.controller,
    this.initialValue,
    this.labelText,
    this.titleText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
    this.validator,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.isFieldRequired = false,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.inputFormatters,
    this.prefix,
    this.prefixIcon,
    this.style
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: TextFormFieldSizeConstants.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleText != null
              ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          titleText!,
                          style: const TextStyle(
                              fontSize: SharedSize.textFiledTitleSize),
                        ),
                        isFieldRequired
                            ? Text(
                                ' *',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
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
          TextFormField(
            controller: controller,
            // initialValue: 'initialValue',
            onTap: onTap,
            decoration: InputDecoration(
              // labelText: labelText,
              hintText: labelText,
              filled: true,
              // fillColor: Colors.white,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    TextFormFieldSizeConstants.borderRadius),
                // borderSide: BorderSide(
                //   color: Colors.red,
                //   width: 10.0,
                // ),
              ),

              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              suffixIcon: suffixIcon,
              prefix: prefix,
              prefixIcon: prefixIcon,
            ),
            obscureText: obscureText,
            keyboardType: keyboardType,
            autofocus: autofocus,
            validator: validator,
            textInputAction: textInputAction,
            // focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
            enabled: enabled,
            maxLines: maxLines,
            onChanged: onChanged,
            readOnly: readOnly,
            inputFormatters: inputFormatters,
            style: style,
          ),

        ],
      ),
    );
  }
}
