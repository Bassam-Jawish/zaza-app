import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:zaza_app/features/discount/presentation/bloc/discount_bloc.dart';
import 'package:zaza_app/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:zaza_app/features/product/presentation/bloc/new_product/new_product_bloc.dart';
import 'package:zaza_app/features/product/presentation/bloc/product/product_bloc.dart';

import '../../../../core/app_export.dart';

Widget likeButtonWidget(
  context,
  double sizeIcon,
  int productId,
  int type,
  int index,
    state,
) {
  return LikeButton(
    onTap: (bool isLiked) async {
      if (type == 0) {
        // Favorite 0
        BlocProvider.of<ProductBloc>(context)
            .add(AddToFavoriteHomeNewProducts(productId, index));
        isLiked = state.newHomeProductsFavorites![productId]!;
        print(isLiked);
        return state.productStatus == ProductStatus.addedToFavoriteNewProducts
            ? !isLiked
            : isLiked;
      } else if (type == 1) {
        // Search By Barcode 1
        BlocProvider.of<ProductBloc>(context)
            .add(AddToFavoriteSearchByBarCode(productId, index));
        isLiked = state.searchBarcodeProductsFavorites![productId]!;
        print(isLiked);
        return state.productStatus ==
                ProductStatus.addedToFavoriteSearchByBarcode
            ? !isLiked
            : isLiked;
      } else if (type == 2) {
        // Search By Name 2
        BlocProvider.of<ProductBloc>(context)
            .add(AddToFavoriteSearchByName(productId, index));
        isLiked = state.searchNameProductsFavorites![productId]!;
        print(isLiked);
        return state.productStatus == ProductStatus.addedToFavoriteSearchByName
            ? !isLiked
            : isLiked;
      } else if (type == 3) {
        // Get Favorite 3
        BlocProvider.of<FavoriteBloc>(context)
            .add(AddToFavoriteFav(productId, index));
        isLiked = state.favorites![productId]!;
        print(isLiked);
        return state.favoriteStatus == FavoriteStatus.addedToFavorite
            ? !isLiked
            : isLiked;
      } else if (type == 4) {
        // Get DiscountBloc 4
        BlocProvider.of<DiscountBloc>(context)
            .add(AddToFavoriteDiscount(productId, index));
        isLiked = state.favorites![productId]!;
        print(isLiked);
        return state.discountStatus == DiscountStatus.addedToFavorite
            ? !isLiked
            : isLiked;
      } else if (type == 5) {
        // Get AllNewProducts 5
        BlocProvider.of<NewProductBloc>(context)
            .add(AddToFavoriteNewProducts(productId, index));
        isLiked = state.newAllProductsFavorites![productId]!;
        print(isLiked);
        return state.newProductStatus == NewProductStatus.addedToFavorite
            ? !isLiked
            : isLiked;
      } else if (type == 6) {
        // Get CategoryBloc 6
        BlocProvider.of<CategoryBloc>(context)
            .add(AddToFavoriteCategory(productId, index));
        isLiked = state.favorites![productId]!;
        print(isLiked);
        return state.categoryStatus == CategoryStatus.addedToFavorite
            ? !isLiked
            : isLiked;
      }
    },
    likeBuilder: (bool isLiked) {
      return Icon(
        Icons.favorite,
        color: type == 0
            ? state.newHomeProductsFavorites![productId] == true
                ? Colors.red
                : Colors.grey
            : type == 1
                ? state.searchBarcodeProductsFavorites![productId] == true
                    ? Colors.red
                    : Colors.grey
                : type == 2
                    ? state.searchNameProductsFavorites![productId] == true
                        ? Colors.red
                        : Colors.grey
                    : type == 3
                        ? state.favorites![productId] == true
                            ? Colors.red
                            : Colors.grey
                        : type == 4
                            ? state.favorites![productId] == true
                                ? Colors.red
                                : Colors.grey
                            : type == 5
                                ? state.newAllProductsFavorites![productId] ==
                                        true
                                    ? Colors.red
                                    : Colors.grey
                                : state.favorites![productId] == true
                                    ? Colors.red
                                    : Colors.grey,
        size: sizeIcon,
      );
    },
  );
}
