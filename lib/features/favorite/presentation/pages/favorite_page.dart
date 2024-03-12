import 'package:easy_debounce/easy_debounce.dart';
import 'package:zaza_app/core/app_export.dart';
import 'package:zaza_app/core/widgets/custom_appbar.dart';
import 'package:zaza_app/features/favorite/presentation/bloc/favorite_bloc.dart';
import '../../../../core/widgets/custom_floating.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../injection_container.dart';
import '../widgets/favorite_body.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider<FavoriteBloc>(
  create: (context) => sl()..add(GetFavoriteProducts(limit, 0, sort, '', languageCode, true)),
  child: BlocConsumer<FavoriteBloc, FavoriteState>(
  listener: (context, state) {
    if (state.favoriteStatus == FavoriteStatus.error) {
      showToast(text: state.error!.message, state: ToastState.error);
    }
    if (state.favoriteStatus == FavoriteStatus.changeSort) {
      context.read<FavoriteBloc>()
        ..add(GetFavoriteProducts(
            limit, 0, sort, '', languageCode, true));

    }
    if (state.favoriteStatus == FavoriteStatus.paginated) {
      context.read<FavoriteBloc>()
        ..add(GetFavoriteProducts(
            limit, state.favoriteCurrentIndex!, sort, '', languageCode, false));
    }
  },
  builder: (context, state) {
    return Scaffold(
      backgroundColor: theme.background,
      appBar: CustomAppBar(AppLocalizations.of(context)!.favorite_Products, width, height, context, false,false),
      body: FavoriteBody(state),
      floatingActionButton:
      sortFloatingButton('FavoriteBloc', context, () {
        EasyDebounce.debounce(
            'my-debouncer',
            const Duration(milliseconds: 300),
                () => context.read<FavoriteBloc>().add(ChangeSortFavorite()));
      }),
    );
  },
),
);
  }
}
