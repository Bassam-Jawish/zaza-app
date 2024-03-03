import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:zaza_app/injection_container.dart';

import '../../../../core/app_export.dart';


Future<Object?> awsDialogSendOrder(
    context, width, int type) {
  return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      borderSide: const BorderSide(
        color: Colors.yellow,
        width: 2,
      ),
      btnCancelText: '${AppLocalizations.of(context)!.cancel}',
      btnOkText: '${AppLocalizations.of(context)!.ok}',
      width: width * 0.8,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: true,
      animType: AnimType.topSlide,
      title: '${AppLocalizations.of(context)!.warning}',
      desc: '${AppLocalizations.of(context)!.send_Order}',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        if (type == 0) {
          //Send Order
          BlocProvider.of<BasketBloc>(context).add(SendOrder(languageCode));
        }
      }).show();
}