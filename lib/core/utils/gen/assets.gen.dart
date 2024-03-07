/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  $AssetsImagesBasketGen get basket => const $AssetsImagesBasketGen();

  /// File path: assets/images/image_not_found.png
  AssetGenImage get imageNotFound => const AssetGenImage('assets/images/image_not_found.png');

  /// File path: assets/images/img_email.svg
  SvgGenImage get imgEmail => const SvgGenImage('assets/images/img_email.svg');

  /// File path: assets/images/img_password.svg
  SvgGenImage get imgPassword => const SvgGenImage('assets/images/img_password.svg');

  $AssetsImagesLogosGen get logos => const $AssetsImagesLogosGen();
  $AssetsImagesOnboardingGen get onboarding => const $AssetsImagesOnboardingGen();

  /// File path: assets/images/profile.png
  AssetGenImage get profile => const AssetGenImage('assets/images/profile.png');

  /// List of all assets
  List<dynamic> get values => [imageNotFound, imgEmail, imgPassword, profile];
}

class $AssetsImagesBasketGen {
  const $AssetsImagesBasketGen();

  /// File path: assets/images/basket/Price-cuate.svg
  SvgGenImage get priceCuate => const SvgGenImage('assets/images/basket/Price-cuate.svg');

  /// List of all assets
  List<SvgGenImage> get values => [priceCuate];
}

class $AssetsImagesLogosGen {
  const $AssetsImagesLogosGen();

  /// File path: assets/images/logos/Logo1024.png
  AssetGenImage get logo1024 => const AssetGenImage('assets/images/logos/Logo1024.png');

  /// File path: assets/images/logos/Logo_Colored_512.png
  AssetGenImage get logoColored512 => const AssetGenImage('assets/images/logos/Logo_Colored_512.png');

  /// File path: assets/images/logos/Logo_White_512.png
  AssetGenImage get logoWhite512 => const AssetGenImage('assets/images/logos/Logo_White_512.png');

  /// List of all assets
  List<AssetGenImage> get values => [logo1024, logoColored512, logoWhite512];
}

class $AssetsImagesOnboardingGen {
  const $AssetsImagesOnboardingGen();

  /// File path: assets/images/onboarding/undraw_shopping_app_flsj.svg
  SvgGenImage get undrawShoppingAppFlsj => const SvgGenImage('assets/images/onboarding/undraw_shopping_app_flsj.svg');

  /// File path: assets/images/onboarding/undraw_successful_purchase_re_mpig.svg
  SvgGenImage get undrawSuccessfulPurchaseReMpig => const SvgGenImage('assets/images/onboarding/undraw_successful_purchase_re_mpig.svg');

  /// List of all assets
  List<SvgGenImage> get values => [undrawShoppingAppFlsj, undrawSuccessfulPurchaseReMpig];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
