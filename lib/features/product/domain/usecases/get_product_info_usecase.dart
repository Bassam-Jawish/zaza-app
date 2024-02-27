import 'package:zaza_app/features/product/domain/entities/product.dart';
import 'package:zaza_app/features/product/domain/repository/product_repo.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class GetProductInfoUseCase
    implements UseCase<DataState<ProductData>, ProductInfoParams> {
  final ProductRepository productRepository;

  GetProductInfoUseCase(this.productRepository);

  @override
  Future<DataState<ProductData>> call({ProductInfoParams? params}) {
    return productRepository.getProductInfo(params!.productId, params.language);
  }
}

class ProductInfoParams {
  final int productId;
  final dynamic language;

  ProductInfoParams({required this.productId, required this.language});
}
