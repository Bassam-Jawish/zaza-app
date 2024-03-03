import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_app/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:zaza_app/features/search/presentation/widgets/search_by_barcode.dart';
import 'package:zaza_app/features/search/presentation/widgets/search_by_name.dart';

import '../../../../core/app_export.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

import '../../../../core/widgets/custom_toast.dart';

class SearchBody extends StatelessWidget {
  SearchBody(this.searchByProductNameController, this.searchByBarcodeController,
      {super.key});

  TextEditingController searchByProductNameController;

  TextEditingController searchByBarcodeController;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state.productStatus == ProductStatus.errorBarcodeSearch) {
          showToast(text: state.error!.message, state: ToastState.error);
        }
        if (state.productStatus == ProductStatus.errorNameSearch) {
          showToast(text: state.error!.message, state: ToastState.error);
        }
      },
      builder: (context, state) {
        return ContainedTabBarView(
          tabs: [
            //Text('Product Id'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${AppLocalizations.of(context)!.product_Id}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${AppLocalizations.of(context)!.product_Name}'),
            ),
          ],
          tabBarProperties: TabBarProperties(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: ContainerTabIndicator(
              radius: BorderRadius.circular(12.0.r),
              color: theme.primary,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: theme.secondary,
          ),
          views: [
            //searchByProductId(context, width, height, cubit),
            SearchByBarcode(state, searchByBarcodeController),
            SearchByName(state, searchByProductNameController),
          ],
          onChange: (index) {
            FocusManager.instance.primaryFocus?.unfocus();
            print(index);
          },
        );
      },
    );
  }
}
