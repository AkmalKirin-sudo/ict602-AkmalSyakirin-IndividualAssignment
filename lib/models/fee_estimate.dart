/// The two ticket classes supported by the estimator.
///
/// Keeping the allowance as part of the enum makes the calculation and the UI
/// share one source of truth.
enum TicketClass {
  economy(label: 'Economy', freeAllowanceKg: 20),
  business(label: 'Business', freeAllowanceKg: 40);

  const TicketClass({required this.label, required this.freeAllowanceKg});

  final String label;
  final double freeAllowanceKg;

  /// Whole-kilogram allowance used for labels such as "20 kg free".
  int get freeAllowanceWholeKg => freeAllowanceKg.toInt();
}

/// An immutable snapshot of one excess baggage estimate.
class FeeEstimate {
  const FeeEstimate({
    required this.ticketClass,
    required this.checkedWeightKg,
    required this.ratePerKg,
    required this.excessWeightKg,
    required this.excessCharge,
    required this.serviceTax,
  });

  final TicketClass ticketClass;
  final double checkedWeightKg;
  final double ratePerKg;
  final double excessWeightKg;
  final double excessCharge;
  final double serviceTax;

  double get totalPayable => excessCharge + serviceTax;

  bool get isWithinAllowance => excessWeightKg <= 0;
}

/// Pure business logic for the estimator - kept separate from the widgets so
/// it can be unit tested without pumping a single frame.
abstract final class FeeCalculator {
  static const double serviceTaxRate = 0.08;

  static FeeEstimate calculate({
    required TicketClass ticketClass,
    required double checkedWeightKg,
    required double ratePerKg,
  }) {
    if (checkedWeightKg.isNaN || checkedWeightKg < 0) {
      throw ArgumentError.value(
        checkedWeightKg,
        'checkedWeightKg',
        'Weight must be a non-negative number.',
      );
    }
    if (ratePerKg.isNaN || ratePerKg < 0) {
      throw ArgumentError.value(
        ratePerKg,
        'ratePerKg',
        'Rate must be a non-negative number.',
      );
    }

    final rawExcess = checkedWeightKg - ticketClass.freeAllowanceKg;
    final excessWeight = rawExcess > 0 ? rawExcess : 0.0;
    final excessCharge = excessWeight * ratePerKg;
    final serviceTax = excessCharge * serviceTaxRate;

    return FeeEstimate(
      ticketClass: ticketClass,
      checkedWeightKg: checkedWeightKg,
      ratePerKg: ratePerKg,
      excessWeightKg: excessWeight,
      excessCharge: excessCharge,
      serviceTax: serviceTax,
    );
  }
}
