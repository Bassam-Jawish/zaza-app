import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/core/widgets/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zaza_app/core/widgets/custom_toast.dart';
import 'package:zaza_app/features/search/presentation/widgets/search_body.dart';

import '../../../../injection_container.dart';
import '../../../product/presentation/bloc/product/product_bloc.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final TextEditingController searchByProductNameController =
      TextEditingController();

  final TextEditingController searchByBarcodeController =
      TextEditingController();

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
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: theme.background,
            appBar: CustomAppBar(AppLocalizations.of(context)!.search, width,
                height, context, true, false),
            body: SearchBody(
                searchByProductNameController, searchByBarcodeController),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                context.read<ProductBloc>().add(ScanBarcode());
                searchByBarcodeController.text = state.scanBarcode!;
                context.read<ProductBloc>().add(GetSearchBarcodeProducts(
                    limit,
                    0,
                    'newest',
                    searchByBarcodeController.text,
                    languageCode,
                    true));
              },
              elevation: 0.0,
              label: Text(
                '${AppLocalizations.of(context)!.sCAN_BARCODE}',
              ),
              icon: Icon(Icons.camera_alt),
              backgroundColor: theme.primary,
              foregroundColor: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
