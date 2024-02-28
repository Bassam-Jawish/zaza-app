import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/config/config.dart';
import 'package:zaza_app/core/widgets/custom_image_view.dart';
import 'package:zaza_app/features/basket/presentation/pages/basket_page.dart';
import 'package:zaza_app/features/categories/presentation/pages/categories_page.dart';

import '../../../../injection_container.dart';
import '../../../base/presentation/widgets/push_bottom_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard(
      this.main_id, this.categoryName, this.imagePath, this.itemsNumber,
      {super.key});

  final int main_id;
  final String categoryName;
  final String imagePath;
  final int itemsNumber;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var theme = Theme.of(context).colorScheme;
    String path = '${baseUrl}/${imagePath}';
    return GestureDetector(
      onTap: () {
        categoryId = main_id;
        pushNewScreenWithNavBar(context, CategoryPage(), '/categories');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0.1),
              color: Colors.redAccent.withOpacity(0.2),
              blurRadius: 6,
            )
          ],
        ),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.015, vertical: height * 0.005),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: CustomImageView(
              imagePath: path,
              width: double.infinity,
              height: height * 0.16,
              fit: BoxFit.contain,
            )),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              categoryName,
              style: TextStyle(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: height * 0.005,
            ),
            Text(
              '${itemsNumber.toString()} ${AppLocalizations.of(context)!.items}',
              style: TextStyle(
                  color: theme.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
    ;
  }
}
