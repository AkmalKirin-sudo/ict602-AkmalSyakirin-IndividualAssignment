import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:individual_assignment_ict602/main.dart';
import 'package:individual_assignment_ict602/screens/about_screen.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AirBaggageApp());
    await tester.pumpAndSettle();
  }

  Future<void> selectBusiness(WidgetTester tester) async {
    await tester.tap(find.text('Business · 40 kg'));
    await tester.pump();
  }

  Future<void> calculate(
    WidgetTester tester, {
    required String weight,
    required String rate,
  }) async {
    await tester.enterText(find.byKey(const Key('weightField')), weight);
    await tester.enterText(find.byKey(const Key('rateField')), rate);
    await tester.ensureVisible(find.byKey(const Key('btnCalculate')));
    await tester.tap(find.byKey(const Key('btnCalculate')));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the calculator home screen', (tester) async {
    await pumpApp(tester);

    expect(find.byKey(const Key('appBarTitle')), findsOneWidget);
    expect(find.text('AirBaggage Fee Estimator'), findsWidgets);
    expect(find.text('Good to know'), findsOneWidget);
    expect(find.text('Ticket Class'), findsOneWidget);
    expect(find.byKey(const Key('weightField')), findsOneWidget);
    expect(find.byKey(const Key('rateField')), findsOneWidget);
    expect(find.byKey(const Key('btnCalculate')), findsOneWidget);
    expect(find.byKey(const Key('btnReset')), findsOneWidget);
    expect(find.byKey(const Key('navHome')), findsOneWidget);
    expect(find.byKey(const Key('navAbout')), findsOneWidget);
  });

  testWidgets('calculates an excess fee including 8% tax', (tester) async {
    await pumpApp(tester);
    await selectBusiness(tester);
    await calculate(tester, weight: '42.5', rate: '12');

    expect(find.text('Fee Summary'), findsOneWidget);
    expect(find.text('2.5 kg'), findsOneWidget);
    expect(find.text('RM 30.00'), findsOneWidget);
    expect(find.text('RM 2.40'), findsOneWidget);
    expect(find.text('RM 32.40'), findsOneWidget);
    expect(find.text('Includes 8% service tax'), findsOneWidget);
    expect(find.text('Within Free Allowance — No Excess Fee!'), findsNothing);
  });

  testWidgets('shows the free allowance badge at or below the limit', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Economy · 20 kg'));
    await tester.pump();
    await calculate(tester, weight: '20', rate: '12');

    expect(find.text('Within Free Allowance — No Excess Fee!'), findsOneWidget);
    expect(find.text('0.0 kg'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('totalPayableValue'))).data,
      'RM 0.00',
    );
  });

  testWidgets('validates empty fields with inline messages', (tester) async {
    await pumpApp(tester);
    await tester.ensureVisible(find.byKey(const Key('btnCalculate')));
    await tester.tap(find.byKey(const Key('btnCalculate')));
    await tester.pumpAndSettle();

    expect(find.text('Select a ticket class to continue.'), findsOneWidget);
    expect(find.text('Enter the checked baggage weight.'), findsOneWidget);
    expect(find.text('Enter the rate per kg.'), findsOneWidget);
    expect(find.text('Please check the highlighted fields.'), findsOneWidget);
    expect(find.text('Fee Summary'), findsNothing);
  });

  testWidgets('preserves the estimate when switching to About and back', (
    tester,
  ) async {
    await pumpApp(tester);
    await selectBusiness(tester);
    await calculate(tester, weight: '42.5', rate: '12');
    expect(find.text('RM 32.40'), findsOneWidget);

    await tester.tap(find.byKey(const Key('navAbout')));
    await tester.pumpAndSettle();

    expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 1);
    expect(find.text(AboutScreen.authorName), findsOneWidget);
    expect(find.text(AboutScreen.matricNo), findsOneWidget);
    expect(find.text(AboutScreen.course), findsOneWidget);
    expect(find.text(AboutScreen.githubUrl), findsOneWidget);
    expect(find.byKey(const Key('githubButton')), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);

    await tester.tap(find.byKey(const Key('navHome')));
    await tester.pumpAndSettle();
    expect(find.text('RM 32.40'), findsOneWidget);
  });
}
