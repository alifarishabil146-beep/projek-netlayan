import 'package:flutter/material.dart';

class NetlayanImage extends StatelessWidget {
  final String? assetPath;
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final IconData fallbackIcon;

  const NetlayanImage({
    super.key,
    this.assetPath,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 12.0,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.set_meal,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: assetPath != null
            ? Image.asset(
                assetPath!,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (context, error, stackTrace) {
                  return _buildNetworkOrFallback();
                },
              )
            : _buildNetworkOrFallback(),
      ),
    );
  }

  Widget _buildNetworkOrFallback() {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: const Color(0xFFE6EEF4), // Kotak abu kebiruan (#E6EEF4)
        child: Icon(fallbackIcon, size: width * 0.4, color: const Color(0xFF005B96)),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: const Color(0xFFE6EEF4),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
