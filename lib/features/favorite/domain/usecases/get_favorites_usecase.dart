import 'package:zaza_app/features/favorite/domain/repository/favorite_repo.dart';
import 'package:zaza_app/features/product/domain/entities/product.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class GetFavoritesUseCase
    implements UseCase<DataState<ProductEntity>, FavoriteParams> {
  final FavoriteRepository favoriteRepository;

  const GetFavoritesUseCase(this.favoriteRepository);

  @override
  Future<DataState<ProductEntity>> call({FavoriteParams? params}) {
    return favoriteRepository.getFavoriteProducts(
        params!.limit, params.page, params.sort, params.search, params.language);
  }
}

class FavoriteParams {
  final int limit;
  final int page;

  final String sort;
  final String search;

  final String language;

  FavoriteParams({
    required this.limit,
    required this.page,
    required this.sort,
    required this.search,
    required this.language,
  });
}
