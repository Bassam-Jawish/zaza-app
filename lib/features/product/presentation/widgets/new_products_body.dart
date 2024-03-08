import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/features/product/presentation/bloc/new_product/new_product_bloc.dart';
import 'package:zaza_app/features/product/presentation/widgets/product_card.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/app_export.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../injection_container.dart';

class NewProductsBody extends StatelessWidget {
  const NewProductsBody(this.state, {super.key});

  final NewProductState state;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return state.isNewProductsLoaded!
        ? SingleChildScrollView(
            controller: state.scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColor.secondaryLight,
                          size: 20,
                        ),
                        iconSize: 20,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.number_of_Products} (${state.newAllProductsEntity!.totalNumber})',
                        style: TextStyle(
                            color: theme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp),
                      ),
                      /*sort == 'newest'
                          ? Text(
                              '(${AppLocalizations.of(context)!.newest})',
                              style: TextStyle(
                                  color: theme.primary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp),
                            )
                          : Text(
                              '(${AppLocalizations.of(context)!.oldest})',
                              style: TextStyle(
                                  color: theme.primary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp),
                            ),*/
                    ],
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: width * 0.5,
                      mainAxisExtent: height * 0.36,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index < state.newAllProductsList!.length) {
                        return ProductCard(
                            index,
                            state.newAllProductsList![index].productId!,
                            state.newAllProductsList![index].productName!,
                            state.newAllProductsList![index].image!,
                            state.newAllProductsList![index].barCode!,
                            state.newAllProductsList![index].discount!,
                            state.newAllProductsList![index]
                                .productUnitListModel![0].productUnitId!,
                            state.newAllProductsList![index]
                                .productUnitListModel![0].unitName!,
                            state.newAllProductsList![index]
                                .productUnitListModel![0].description!,
                            0,
                            state.newAllProductsList![index]
                                .productUnitListModel![0].quantity!,
                            5,
                            state.newAllProductsList![index]
                                .productUnitListModel![0].price!,
                            state);
                      }
                    },
                    itemCount: state.newProductStatus ==
                            NewProductStatus.loadingAllNewProductsPaginated
                        ? state.newAllProductsList!.length
                        : state.newAllProductsList!.length + 1,
                  ),
                  state.newProductStatus ==
                          NewProductStatus.loadingAllNewProductsPaginated
                      ? Center(child: SpinKitApp(width))
                      : SizedBox(),
                ],
              ),
            ),
          )
        : SpinKitApp(width);
  }
}
