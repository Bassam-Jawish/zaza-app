import 'package:flutter/material.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/core/widgets/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/widgets/custom_floating.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../injection_container.dart';
import '../widgets/category_body.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<CategoryBloc>(
      create: (BuildContext context) => sl()
        ..add(GetCategoryChildren(categoryId, 0, limit, languageCode, true)),
      child: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state.categoryStatus == CategoryStatus.error) {
            showToast(text: state.error!.message, state: ToastState.error);
          }
          if (state.categoryStatus == CategoryStatus.paginated) {
            context.read<CategoryBloc>().add(GetCategoryChildren(
                categoryId, state.currentIndex!, limit, languageCode, false));
          }
          if (state.categoryStatus == CategoryStatus.changeSort) {
            context.read<CategoryBloc>().add(GetCategoryChildren(
                categoryId, 0, limit, languageCode, true));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar('${AppLocalizations.of(context)!.categories}',
                width, height, context, true, false),
            body: CategoryBody(state),
            /*floatingActionButton: state.screenType == 'leaf'
                ? sortFloatingButton('CategoryBloc', context, () {
                    context.read<CategoryBloc>().add(ChangeSortCategory());
                  })
                : SizedBox(),*/
          );
        },
      ),
    );
  }
}
