import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../../core/app_export.dart';
import '../../../../injection_container.dart';

Future<Object?> awsDialogLogout(
    context, width, int type) {
  return AwesomeDialog(
      dialogBackgroundColor: Colors.white,
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
      desc: type == 0 ? '${AppLocalizations.of(context)!.do_you_logout}' : '${AppLocalizations.of(context)!.do_you_account}',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        if (type == 0) {
          //Logout
          BlocProvider.of<AuthBloc>(context).add(Logout());
          BlocProvider.of<BasketBloc>(context).add(DeleteBasket(true));
        } else {
          //Delete Account
          BlocProvider.of<AuthBloc>(context).add(DeleteAccount());
          BlocProvider.of<BasketBloc>(context).add(DeleteBasket(true));
        }
      }).show();
}