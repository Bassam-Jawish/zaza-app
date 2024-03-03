import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../../core/app_export.dart';

Future<Object?> awsDialogDeleteForAll(
    context, width, int type) {
  return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      borderSide: const BorderSide(
        color: Colors.yellow,
        width: 2,
      ),
      width: width * 0.8,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      btnCancelText: '${AppLocalizations.of(context)!.cancel}',
      btnOkText: '${AppLocalizations.of(context)!.ok}',
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: true,
      animType: AnimType.topSlide,
      title: '${AppLocalizations.of(context)!.warning}',
      desc: '${AppLocalizations.of(context)!.delete_Items_from_basket}',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        if (type == 0) {
          //Delete basketInfo
          BlocProvider.of<BasketBloc>(context).add(DeleteBasket());
        }
      }).show();
}

Future<Object?> awsDialogDeleteForOne(context, width, int type, int index) {
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
      desc: '${AppLocalizations.of(context)!.delete_the_Item}',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        if (type == 0) {
          //Delete productBasketInfo
          BlocProvider.of<BasketBloc>(context).add(RemoveOneFromBasket(index));
        }
      }).show();
}
