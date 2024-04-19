import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/injection_container.dart';
import '../../../../core/app_export.dart';
import '../../../../core/widgets/custom_toast.dart';

Future addPhoneDialog(BuildContext context, width, height) {
  TextEditingController save = TextEditingController();
  return showDialog(
      context: context,
      barrierLabel: '',
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.add_Phone_Number}',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.secondaryLight),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: height * 0.012,
                  thickness: 2,
                  color: Colors.grey,
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.005, vertical: height * 0.01),
                child: Container(
                  height: height * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.8,
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            /* BlocProvider.of<ProfileBloc>(context)
                                  ..add(AddingPhoneNumber(
                                      number.phoneNumber!,
                                      number.dialCode!));*/
                            phoneNumber = save.text;
                            dialCode = number.dialCode!;
                          },
                          spaceBetweenSelectorAndTextField: 4,
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.DIALOG,
                          ),
                          textFieldController: save,
                          inputDecoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle:
                                const TextStyle(color: AppColor.secondaryLight),
                            fillColor: const Color(0xFFFCFCFC),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                          ),
                          cursorColor: Colors.red,
                          ignoreBlank: false,
                          formatInput: false,
                          //textFieldController: state.phoneController!,
                          selectorTextStyle:
                              const TextStyle(color: Colors.black),
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          onSaved: (PhoneNumber number) {
                            print(number.phoneNumber);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '${AppLocalizations.of(context)!.please_enter_phone_number}';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => AppColor.shadeColor),
                ),
                onPressed: () {
                  //state.phoneController!.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  '${AppLocalizations.of(context)!.cancel}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      color: AppColor.gray500),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => AppColor.shadeColor),
                ),
                onPressed: () {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(CreatePhone(languageCode));
                },
                child: Text(
                  '${AppLocalizations.of(context)!.add}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      color: AppColor.primaryLight),
                ),
              ),
            ],
          ));
}
