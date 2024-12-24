import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final int? maxLines;
  final Function(String)? onChanged;
  final bool isFieldRequired;
  final Widget? suffixIcon;
  final Function()? onTap;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? prefixIcon;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextAlign textAlign;

  const MyTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.labelText,
    this.titleText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
    this.validator,
    this.textInputAction = TextInputAction.next,
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
    this.style,
    this.textDirection,
    this.textAlign = TextAlign.start
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TextFormFieldSizeConstants.padding),
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
                          style: TextStyle(fontSize: SharedSize.textFiledTitleSize),
                        ),
                        isFieldRequired
                            ? Text(
                                ' *',
                                style: TextStyle(fontSize: SharedSize.textFiledTitleSize, color: Colors.red),
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
          TextFormField(
            controller: controller,
            // initialValue: 'initialValue',
            onTap: onTap,
            decoration: InputDecoration(
              // labelText: labelText,
              hintText: labelText,
              hintStyle: TextStyle(fontSize: 16.sp),
              
              filled: true,
              // fillColor: Colors.white,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TextFormFieldSizeConstants.borderRadius),
                // borderSide: BorderSide(
                //   color: Colors.red,
                //   width: 10.0,
                // ),
              ),

              contentPadding: EdgeInsets.symmetric(vertical: 10.0.w, horizontal: 20.0.w),
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
            textDirection: textDirection,
            textAlign: textAlign,

          ),
        ],
      ),
    );
  }
}
