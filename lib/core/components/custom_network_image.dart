import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/app_colors/app_colors.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.colorFilter,
    this.alignment,
    this.child,
    this.boxShape,
    this.border,
    this.isPlaceholder = false,
    this.errorWidget,
  });

  final String? url;
  final BoxFit fit;
  final double? height;
  final double? width;
  final ColorFilter? colorFilter;
  final Alignment? alignment;
  final Widget? child;
  final BoxBorder? border;
  final BoxShape? boxShape;
  final bool isPlaceholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url ?? '',
      imageBuilder:
          (_, imageProvider) => Container(
            width: width?.w,
            height: height?.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
                colorFilter: colorFilter,
              ),
              shape: boxShape ?? BoxShape.circle,
              border: border,
            ),
            alignment: alignment ?? Alignment.center,
            child: child,
          ),
      placeholder:
          (_, __) => Container(
            width: width?.w,
            height: height?.h,
            decoration: BoxDecoration(
              shape: boxShape ?? BoxShape.circle,
              border: border,
            ),
            alignment: alignment ?? Alignment.center,
            child: child,
          ),
      errorWidget:
          (_, __, ___) =>
              errorWidget ??
              Container(
                width: width?.w,
                height: height?.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: border,
                  shape: boxShape ?? BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
    );
  }
}
