import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';

import '../../../../core/app_export.dart';
import '../../../../core/widgets/default_textformfield.dart';
import '../../../../injection_container.dart';

Future quantityDialog(width, height, context, int quantity, formKey,
    int productId, int productUnitId) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => BlocBuilder<BasketBloc, BasketState>(
        builder: (context, state) {
          return AlertDialog(
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.01, vertical: height * 0.02),
                child: Text('${AppLocalizations.of(context)!.basket}')),
            titleTextStyle: TextStyle(
              color: AppColor.primaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: Container(
                  height: height * 0.2,
                  width: width * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.enter_quantity_unit}',
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColor.secondaryLight),
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        def_TextFromField_search(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          controller: state.quantityController!,
                          onChanged: (value) {
                             BlocProvider.of<BasketBloc>(context).add(ChangeTextValue(value, state.quantityController!.text!));
                          },
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          maxLength: 10,
                          br: 15,
                          counterText:
                              '${state.quantityController!.text}/${quantity}',
                          validator: (value) {
                            if (value != '') {
                              if ((int.parse(value) > quantity)) {
                                return '${AppLocalizations.of(context)!.not_available}';
                              }
                            }
                            if (value!.isEmpty || value == '0') {
                              return '${AppLocalizations.of(context)!.empty}';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
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
                  Navigator.pop(context);
                  context.read<BasketBloc>().add(ClearQuantityController());
                },
                child: Text(
                  '${AppLocalizations.of(context)!.cancel}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      color: AppColor.secondaryLight),
                ),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => AppColor.shadeColor),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<BasketBloc>().add(AddToBasket(productUnitId,
                        int.parse(state.quantityController!.text)));
                    context.read<BasketBloc>().add(ClearQuantityController());
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  '${AppLocalizations.of(context)!.aDD_TO_BASKET}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      color: AppColor.primaryLight),
                ),
              ),
            ],
          );
        },
      ),
  );
}
