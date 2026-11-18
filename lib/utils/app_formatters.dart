/// Presentation helpers for the numbers shown in the summary card.
abstract final class AppFormatters {
  /// Formats a weight with one or two decimal places, e.g. `2.5 kg`, `0.0 kg`
  /// or `12.75 kg`. Negative values are never shown to the user.
  static String weightKg(double value) {
    final safeValue = value < 0 ? 0.0 : value;
    final fixed = safeValue.toStringAsFixed(2);
    final trimmed = fixed.endsWith('0')
        ? fixed.substring(0, fixed.length - 1)
        : fixed;
    return '$trimmed kg';
  }

  /// Formats an amount as Ringgit Malaysia with two decimals and thousands
  /// separators, e.g. `RM 32.40` or `RM 1,280.00`.
  static String ringgit(double value) {
    final safeValue = value.abs();
    final fixed = safeValue.toStringAsFixed(2);
    final parts = fixed.split('.');
    final grouped = parts.first.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    final sign = value < 0 ? '-' : '';
    return '${sign}RM $grouped.${parts.last}';
  }
}
