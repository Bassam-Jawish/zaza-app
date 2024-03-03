import 'package:flutter/material.dart';
import 'package:zaza_app/config/theme/colors.dart';
import 'package:zaza_app/core/app_export.dart';

Widget sortFloatingButton(String bloc, context, VoidCallback? onPressed) {
  return FloatingActionButton(
    onPressed: onPressed,/*() {
      if (bloc == 'DiscountBloc') {
        print('hahha');
        BlocProvider.of<DiscountBloc>(context).add(ChangeSortDiscount());
      } else if (bloc == 'FavoriteBloc') {
        BlocProvider.of<FavoriteBloc>(context).add(ChangeSortFavorite());
      } else if (bloc == 'NewProductBloc') {
        BlocProvider.of<NewProductBloc>(context).add(ChangeSortNewProducts());
      } else if (bloc == 'CategoryBloc') {
        BlocProvider.of<CategoryBloc>(context).add(ChangeSortCategory());
      }
    },*/
    backgroundColor: AppColor.primaryLight,
    tooltip: 'Sort',
    child: const Icon(
      Icons.sort,
      color: Colors.white,
    ),
  );
}
