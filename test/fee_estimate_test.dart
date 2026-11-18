import 'package:flutter_test/flutter_test.dart';
import 'package:individual_assignment_ict602/models/fee_estimate.dart';
import 'package:individual_assignment_ict602/utils/app_formatters.dart';

void main() {
  group('FeeCalculator', () {
    test('returns zero excess inside the economy allowance', () {
      final result = FeeCalculator.calculate(
        ticketClass: TicketClass.economy,
        checkedWeightKg: 20,
        ratePerKg: 12,
      );

      expect(result.excessWeightKg, 0);
      expect(result.isWithinAllowance, isTrue);
      expect(result.excessCharge, 0);
      expect(result.serviceTax, 0);
      expect(result.totalPayable, 0);
    });

    test('charges excess weight plus 8% service tax', () {
      final result = FeeCalculator.calculate(
        ticketClass: TicketClass.business,
        checkedWeightKg: 42.5,
        ratePerKg: 12,
      );

      expect(result.excessWeightKg, closeTo(2.5, 0.0001));
      expect(result.excessCharge, closeTo(30.00, 0.0001));
      expect(result.serviceTax, closeTo(2.40, 0.0001));
      expect(result.totalPayable, closeTo(32.40, 0.0001));
    });

    test('never produces negative excess weight', () {
      final result = FeeCalculator.calculate(
        ticketClass: TicketClass.business,
        checkedWeightKg: 0,
        ratePerKg: 15,
      );

      expect(result.excessWeightKg, 0);
      expect(result.totalPayable, 0);
      expect(result.isWithinAllowance, isTrue);
    });

    test('uses the correct allowance for each ticket class', () {
      final economy = FeeCalculator.calculate(
        ticketClass: TicketClass.economy,
        checkedWeightKg: 41,
        ratePerKg: 10,
      );
      final business = FeeCalculator.calculate(
        ticketClass: TicketClass.business,
        checkedWeightKg: 41,
        ratePerKg: 10,
      );

      expect(economy.excessWeightKg, closeTo(21, 0.0001));
      expect(business.excessWeightKg, closeTo(1, 0.0001));
    });

    test('rejects negative input defensively', () {
      expect(
        () => FeeCalculator.calculate(
          ticketClass: TicketClass.economy,
          checkedWeightKg: -1,
          ratePerKg: 10,
        ),
        throwsArgumentError,
      );
      expect(
        () => FeeCalculator.calculate(
          ticketClass: TicketClass.economy,
          checkedWeightKg: 10,
          ratePerKg: -1,
        ),
        throwsArgumentError,
      );
    });
  });

  group('AppFormatters', () {
    test('formats weights with one or two decimal places', () {
      expect(AppFormatters.weightKg(0), '0.0 kg');
      expect(AppFormatters.weightKg(2.5), '2.5 kg');
      expect(AppFormatters.weightKg(2.50), '2.5 kg');
      expect(AppFormatters.weightKg(12.75), '12.75 kg');
      expect(AppFormatters.weightKg(-3), '0.0 kg');
    });

    test('formats Ringgit Malaysia with two decimals and separators', () {
      expect(AppFormatters.ringgit(0), 'RM 0.00');
      expect(AppFormatters.ringgit(30), 'RM 30.00');
      expect(AppFormatters.ringgit(32.4), 'RM 32.40');
      expect(AppFormatters.ringgit(1280.5), 'RM 1,280.50');
    });
  });
}
