import 'package:zaza_app/features/favorite/domain/repository/favorite_repo.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class AddToFavoritesUseCase
    implements UseCase<DataState<void>, AddToFavoriteParams> {
  final FavoriteRepository favoriteRepository;

  const AddToFavoritesUseCase(this.favoriteRepository);

  @override
  Future<DataState<void>> call({AddToFavoriteParams? params}) {
    return favoriteRepository.addToFavorite(params!.productId);
  }
}

class AddToFavoriteParams {
  final int productId;
  AddToFavoriteParams({
    required this.productId,
  });
}
