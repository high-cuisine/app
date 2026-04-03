import 'package:flutter/material.dart';

/// Умный виджет для отображения изображений с автоматической обработкой ошибок и загрузки
class SmartNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? semanticsLabel;
  final bool showLoadingIndicator;
  final Color? loadingIndicatorColor;

  const SmartNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.semanticsLabel,
    this.showLoadingIndicator = true,
    this.loadingIndicatorColor,
  });

  /// Конструктор для создания SmartNetworkImage с предустановленными размерами для карточек коктейлей
  const SmartNetworkImage.cocktailCard({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.semanticsLabel,
    this.showLoadingIndicator = true,
    this.loadingIndicatorColor,
  })  : width = double.infinity,
        height = 190;

  /// Конструктор для создания SmartNetworkImage с предустановленными размерами для слайдера
  const SmartNetworkImage.slider({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.semanticsLabel,
    this.showLoadingIndicator = true,
    this.loadingIndicatorColor,
  })  : width = double.infinity,
        height = 340;

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[800],
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            loadingIndicatorColor ?? Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultErrorWidget(Object? error) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            color: Colors.white,
            size: 50,
          ),
          SizedBox(height: 8),
          Text(
            'Изображение недоступно',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Server now provides processed URLs, no client-side conversion needed
    if (imageUrl == null || imageUrl!.isEmpty) {
      return errorWidget ?? _buildDefaultErrorWidget('No image URL provided');
    }

    return Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticsLabel,
      loadingBuilder: showLoadingIndicator
          ? (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return placeholder ??
                  Container(
                    width: width,
                    height: height,
                    color: Colors.grey[800],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          loadingIndicatorColor ?? Colors.white,
                        ),
                      ),
                    ),
                  );
            }
          : null,
      errorBuilder: (context, error, stackTrace) {
        // Логируем ошибку для отладки
        debugPrint('SmartNetworkImage error: $error');
        debugPrint('Image URL: $imageUrl');

        return errorWidget ?? _buildDefaultErrorWidget(error);
      },
    );
  }
}
