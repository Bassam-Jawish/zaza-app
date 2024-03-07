import 'package:flutter/material.dart';
import 'package:zaza_app/core/app_export.dart';

import '../../../../config/theme/styles.dart';

Widget NoSearchFound(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('${AppLocalizations.of(context)!.no_result}',style: Styles.textStyle16.copyWith(color: Colors.black),),
      SizedBox(width: 10,),
      Icon(Icons.search_off,size: 30,),
    ],
  );
}