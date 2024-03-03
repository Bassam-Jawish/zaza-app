import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/theme/colors.dart';

import '../../../../core/app_export.dart';
import '../../../../injection_container.dart';

Future changeLanguageDialog(
  context,
  width,
  height,
) {
  return showDialog(
    context: context,
    builder: (context) => BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return AlertDialog(

          backgroundColor: Colors.white,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.language_Settings}',
                    style: TextStyle(
                        fontSize: 18.sp,
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
                      size: 18.sp,
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
                height: height * 0.24,
                width: width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RadioListTile(
                      value: 1,
                      groupValue: selectedLanguageValue,
                      onChanged: (value) {
                        BlocProvider.of<SettingsBloc>(context)
                            .add(ChangeLanguage(value));
                      },
                      activeColor: AppColor.primaryLight,
                      title: Text('${AppLocalizations.of(context)!.germany}'),
                      selected: selectedLanguageValue == 1,
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedLanguageValue,
                      onChanged: (value) {
                        BlocProvider.of<SettingsBloc>(context)
                            .add(ChangeLanguage(value));
                      },
                      activeColor: AppColor.primaryLight,
                      title: Text('${AppLocalizations.of(context)!.english}'),
                      selected: selectedLanguageValue == 2,
                    ),
                    RadioListTile(
                      value: 3,
                      groupValue: selectedLanguageValue,
                      onChanged: (value) {
                        BlocProvider.of<SettingsBloc>(context)
                            .add(ChangeLanguage(value));
                      },
                      activeColor: AppColor.primaryLight,
                      title: Text('${AppLocalizations.of(context)!.arabic}'),
                      selected: selectedLanguageValue == 3,
                    ),
                    Divider(
                      height: height * 0.012,
                      thickness: 2,
                      color: Colors.grey,
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
                Navigator.pop(context);
              },
              child: Text(
                '${AppLocalizations.of(context)!.ok}',
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
