import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The in-app brand mark: a luggage glyph on an aviation-blue gradient tile.
///
/// A vector mark keeps the logo crisp at every size and avoids introducing
/// off-palette colours into the interface.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.navy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: AppColors.surface.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.22),
            blurRadius: size * 0.35,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: size * 0.12,
            top: size * 0.10,
            child: Container(
              width: size * 0.34,
              height: size * 0.34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface.withValues(alpha: 0.12),
              ),
            ),
          ),
          Icon(
            Icons.luggage_rounded,
            color: AppColors.surface,
            size: size * 0.52,
          ),
        ],
      ),
    );
  }
}
