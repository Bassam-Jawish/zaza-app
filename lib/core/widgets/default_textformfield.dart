import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';

TextFormField def_TextFromField({
  required TextInputType keyboardType,
  required TextEditingController controller,
  required FocusNode focusNode,
  GestureTapCallback? onTap,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onFieldSubmitted,
  FormFieldValidator? validator,
  Widget? prefixIcon,
  Widget? suffixIcon,
  int? maxLength,
  String? counterText = '',
  MaxLengthEnforcement? maxLengthEnforcement,
  bool obscureText = false,
  int maxLines = 1,
  int minLines = 1,
  TextStyle labelStyle = const TextStyle(color: Colors.black),
  Color cursorColor = AppColor.secondaryLight,
  Color borderFocusedColor = AppColor.primaryLight,
  Color borderNormalColor = Colors.black,
  Color fillColor = const Color.fromARGB(255, 236, 236, 237),
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  double br = 25.0,
}) {
  return TextFormField(
    onTap: onTap,
    style: TextStyle(fontSize: 16.sp, color: Colors.black),
    maxLength: maxLength,
    maxLengthEnforcement: maxLengthEnforcement,
    keyboardType: keyboardType,
    controller: controller,
    validator: validator,
    focusNode: focusNode,
    obscureText: obscureText,
    readOnly: false,
    onFieldSubmitted: onFieldSubmitted,
    onChanged: onChanged,
    minLines: minLines,
    maxLines: obscureText ? 1 : maxLines,
    cursorColor: cursorColor,
    autovalidateMode: autovalidateMode,
    decoration: InputDecoration(
      counterText: "",
      border: UnderlineInputBorder(),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderNormalColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderFocusedColor),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      suffixIcon: suffixIcon,
      labelStyle: labelStyle,
    ),
    /*decoration: InputDecoration(
      counterText: counterText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      labelText: label,
      labelStyle: labelStyle,
      fillColor: fillColor,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(br),
        borderSide: BorderSide(
          color: borderFocusedColor,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(br),
        borderSide:  BorderSide(
          color: borderNormalColor,
          width: 2,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(br),
        borderSide:  BorderSide(
          color: borderNormalColor,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(br),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
      ),
    ),*/
  );
}
