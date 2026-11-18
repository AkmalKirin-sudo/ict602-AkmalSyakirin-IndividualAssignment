import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Central colour palette for the app.
///
/// Every UI surface uses one of these aviation-inspired blues (plus white)
/// so the visual language stays consistent from screen to screen.
abstract final class AppColors {
  /// Lightest sky blue - scaffold background and soft summary containers.
  static const Color background = Color(0xFFE3F2FD);

  /// Soft blue - borders, dividers and inactive states.
  static const Color secondary = Color(0xFF90CAF9);

  /// Vibrant blue - primary actions and interactive accents.
  static const Color primary = Color(0xFF2196F3);

  /// Deep navy blue - app bar, headings and high-contrast typography.
  static const Color navy = Color(0xFF0D47A1);

  /// Pure white - cards and elevated surfaces.
  static const Color surface = Color(0xFFFFFFFF);

  /// Standard Material error colour, reserved only for validation feedback.
  static const Color error = Color(0xFFB3261E);
}

abstract final class AppTheme {
  static final ColorScheme _colorScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primary,
        onPrimary: AppColors.surface,
        primaryContainer: AppColors.background,
        onPrimaryContainer: AppColors.navy,
        secondary: AppColors.secondary,
        onSecondary: AppColors.navy,
        secondaryContainer: AppColors.background,
        onSecondaryContainer: AppColors.navy,
        tertiary: AppColors.primary,
        onTertiary: AppColors.surface,
        tertiaryContainer: AppColors.background,
        onTertiaryContainer: AppColors.navy,
        surface: AppColors.surface,
        onSurface: AppColors.navy,
        surfaceContainerLowest: AppColors.surface,
        surfaceContainerLow: AppColors.surface,
        surfaceContainer: AppColors.surface,
        surfaceContainerHigh: AppColors.surface,
        surfaceContainerHighest: AppColors.background,
        onSurfaceVariant: AppColors.navy,
        outline: AppColors.secondary,
        outlineVariant: AppColors.background,
        error: AppColors.error,
        onError: AppColors.surface,
        errorContainer: const Color(0xFFFFE9E7),
        onErrorContainer: AppColors.error,
        shadow: AppColors.navy,
        scrim: AppColors.navy,
        inverseSurface: AppColors.navy,
        onInverseSurface: AppColors.surface,
        inversePrimary: AppColors.secondary,
        surfaceTint: Colors.transparent,
      );

  static ThemeData get light {
    const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.secondary, width: 1.2),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: const AppBarThemeData(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 76,
        titleSpacing: 20,
        iconTheme: IconThemeData(color: AppColors.surface),
        actionsIconTheme: IconThemeData(color: AppColors.surface),
        titleTextStyle: TextStyle(
          color: AppColors.surface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.surface,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: AppColors.background,
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.primary : AppColors.secondary,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected
                ? AppColors.navy
                : AppColors.navy.withValues(alpha: 0.55),
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 0.1,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.surface,
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.error, width: 1.8),
        ),
        labelStyle: TextStyle(
          color: AppColors.navy.withValues(alpha: 0.7),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: AppColors.navy.withValues(alpha: 0.38),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        helperStyle: TextStyle(
          color: AppColors.navy.withValues(alpha: 0.55),
          fontSize: 12,
          height: 1.35,
        ),
        helperMaxLines: 2,
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
        errorMaxLines: 2,
        prefixIconColor: AppColors.primary,
        suffixIconColor: AppColors.primary,
        prefixStyle: const TextStyle(
          color: AppColors.navy,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        suffixStyle: TextStyle(
          color: AppColors.navy.withValues(alpha: 0.7),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withValues(alpha: 0.22),
        selectionHandleColor: AppColors.primary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          disabledBackgroundColor: AppColors.secondary,
          disabledForegroundColor: AppColors.surface,
          elevation: 0,
          minimumSize: const Size(0, 54),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.secondary, width: 1.2),
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? AppColors.surface
                : AppColors.navy;
          }),
          iconColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? AppColors.surface
                : AppColors.primary;
          }),
          overlayColor: WidgetStatePropertyAll(
            AppColors.primary.withValues(alpha: 0.08),
          ),
          side: WidgetStateProperty.resolveWith((states) {
            return BorderSide(
              color: states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.secondary,
              width: 1.2,
            );
          }),
          textStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              color: states.contains(WidgetState.selected)
                  ? AppColors.surface
                  : AppColors.navy,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            );
          }),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.navy,
        contentTextStyle: const TextStyle(
          color: AppColors.surface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
        actionTextColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.secondary.withValues(alpha: 0.45),
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }
}
