import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/fee_estimate.dart';
import '../theme/app_theme.dart';
import '../utils/app_formatters.dart';
import '../widgets/app_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double _contentMaxWidth = 600;

  final _formKey = GlobalKey<FormState>();
  final _resultKey = GlobalKey();
  final _weightController = TextEditingController();
  final _rateController = TextEditingController();
  final _scrollController = ScrollController();

  TicketClass? _selectedClass;
  FeeEstimate? _result;
  String? _classError;
  bool _submitted = false;
  bool _showBanner = true;

  @override
  void dispose() {
    _weightController.dispose();
    _rateController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showSnackBar(
    String message, {
    IconData icon = Icons.info_outline_rounded,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, size: 19, color: AppColors.secondary),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          action: action,
        ),
      );
  }

  void _invalidateResult() {
    if (_result != null) {
      setState(() => _result = null);
    }
  }

  String? _validateWeight(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Enter the checked baggage weight.';
    }
    final weight = double.tryParse(text);
    if (weight == null) {
      return 'Enter a valid number, e.g. 42.5.';
    }
    if (weight < 0) {
      return 'Weight cannot be negative.';
    }
    return null;
  }

  String? _validateRate(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Enter the rate per kg.';
    }
    final rate = double.tryParse(text);
    if (rate == null) {
      return 'Enter a valid amount, e.g. 12.50.';
    }
    if (rate < 0) {
      return 'Rate cannot be negative.';
    }
    return null;
  }

  Future<void> _calculateFee() async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _submitted = true;
      _classError = _selectedClass == null
          ? 'Select a ticket class to continue.'
          : null;
    });

    final fieldsValid = _formKey.currentState?.validate() ?? false;
    if (!fieldsValid || _classError != null) {
      _showSnackBar(
        'Please check the highlighted fields.',
        icon: Icons.error_outline_rounded,
      );
      return;
    }

    final estimate = FeeCalculator.calculate(
      ticketClass: _selectedClass!,
      checkedWeightKg: double.parse(_weightController.text.trim()),
      ratePerKg: double.parse(_rateController.text.trim()),
    );

    setState(() => _result = estimate);
    _showSnackBar(
      'Fee calculated successfully.',
      icon: Icons.check_circle_outline_rounded,
    );

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    final resultContext = _resultKey.currentContext;
    if (resultContext != null && resultContext.mounted) {
      Scrollable.ensureVisible(
        resultContext,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        alignment: 0.04,
      );
    }
  }

  void _resetForm() {
    FocusManager.instance.primaryFocus?.unfocus();
    _weightController.clear();
    _rateController.clear();
    _formKey.currentState?.reset();

    setState(() {
      _selectedClass = null;
      _classError = null;
      _result = null;
      _submitted = false;
      _showBanner = true;
    });

    _showSnackBar(
      'Form cleared. Ready for a new estimate.',
      icon: Icons.refresh_rounded,
    );
  }

  void _dismissBanner() {
    setState(() => _showBanner = false);
    _showSnackBar(
      'Allowance guide hidden.',
      icon: Icons.visibility_off_outlined,
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          if (mounted) {
            setState(() => _showBanner = true);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: _showBanner
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _InfoBanner(onDismiss: _dismissBanner),
                        )
                      : const SizedBox(width: double.infinity),
                ),
                _buildCalculatorCard(),
                AnimatedSize(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: _result == null
                      ? const SizedBox(width: double.infinity)
                      : Padding(
                          key: _resultKey,
                          padding: const EdgeInsets.only(top: 20),
                          child: TweenAnimationBuilder<double>(
                            key: ValueKey(_result),
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 380),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 14 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: _ResultCard(estimate: _result!),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorCard() {
    return AppCard(
      child: Form(
        key: _formKey,
        autovalidateMode: _submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const AppIconBadge(
                  icon: Icons.airplane_ticket_outlined,
                  size: 44,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Baggage details',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tell us about your checked baggage.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.navy.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              'Ticket Class',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.navy.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<TicketClass>(
                key: const Key('ticketClassSelector'),
                segments: const [
                  ButtonSegment<TicketClass>(
                    value: TicketClass.economy,
                    icon: Icon(Icons.flight_takeoff_rounded, size: 17),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Economy · 20 kg'),
                    ),
                    tooltip: 'Economy class - 20 kg free allowance',
                  ),
                  ButtonSegment<TicketClass>(
                    value: TicketClass.business,
                    icon: Icon(Icons.business_center_rounded, size: 17),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Business · 40 kg'),
                    ),
                    tooltip: 'Business class - 40 kg free allowance',
                  ),
                ],
                selected: _selectedClass == null
                    ? const <TicketClass>{}
                    : {_selectedClass!},
                emptySelectionAllowed: true,
                showSelectedIcon: false,
                expandedInsets: EdgeInsets.zero,
                onSelectionChanged: (selection) {
                  setState(() {
                    _selectedClass = selection.isEmpty ? null : selection.first;
                    _classError = null;
                    _result = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 9),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _classError != null
                  ? _InlineMessage(
                      key: const ValueKey('classError'),
                      icon: Icons.error_outline_rounded,
                      text: _classError!,
                      color: AppColors.error,
                    )
                  : _InlineMessage(
                      key: const ValueKey('classHint'),
                      icon: Icons.info_outline_rounded,
                      text: _selectedClass == null
                          ? 'Choose the cabin you are flying in.'
                          : 'Free allowance: '
                                '${_selectedClass!.freeAllowanceWholeKg} kg. '
                                'Only weight above this is charged.',
                    ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              key: const Key('weightField'),
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: const [_DecimalTextInputFormatter()],
              decoration: const InputDecoration(
                labelText: 'Checked Baggage Weight',
                hintText: 'e.g. 42.5',
                prefixIcon: Icon(Icons.scale_outlined),
                suffixText: 'kg',
                helperText: 'Decimals supported - up to 2 decimal places.',
              ),
              validator: _validateWeight,
              onChanged: (_) => _invalidateResult(),
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 18),
            TextFormField(
              key: const Key('rateField'),
              controller: _rateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              inputFormatters: const [_DecimalTextInputFormatter()],
              decoration: const InputDecoration(
                labelText: 'Excess Baggage Rate',
                hintText: 'e.g. 12.00',
                prefixText: 'RM ',
                prefixIcon: Icon(Icons.sell_outlined),
                helperText: 'Rate per kg charged above the free allowance.',
              ),
              validator: _validateRate,
              onChanged: (_) => _invalidateResult(),
              onFieldSubmitted: (_) => _calculateFee(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                key: const Key('btnCalculate'),
                onPressed: _calculateFee,
                icon: const Icon(Icons.calculate_outlined, size: 21),
                label: const Text('Calculate Fee'),
              ),
            ),
            const SizedBox(height: 4),
            TextButton.icon(
              key: const Key('btnReset'),
              onPressed: _resetForm,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reset / Clear'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppIconBadge(
            icon: Icons.info_outline_rounded,
            size: 42,
            foreground: AppColors.navy,
            background: AppColors.surface,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good to know',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: AppColors.navy,
                    ),
                    children: const [
                      TextSpan(text: 'Free baggage allowance: '),
                      TextSpan(
                        text: 'Economy = 20\u00A0kg',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: ', '),
                      TextSpan(
                        text: 'Business = 40\u00A0kg',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: '. An 8% service tax applies to excess charges.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            tooltip: 'Dismiss allowance info',
            icon: const Icon(Icons.close_rounded, size: 18),
            color: AppColors.navy.withValues(alpha: 0.45),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({
    super.key,
    required this.icon,
    required this.text,
    this.color,
  });

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.navy.withValues(alpha: 0.55);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: effectiveColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              fontWeight: FontWeight.w500,
              color: effectiveColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.estimate});

  final FeeEstimate estimate;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppIconBadge(
                icon: Icons.receipt_long_rounded,
                size: 44,
                iconSize: 21,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fee Summary',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Your estimate at a glance.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.navy.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${estimate.ticketClass.label} · '
                  '${estimate.ticketClass.freeAllowanceWholeKg} kg',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (estimate.isWithinAllowance) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.6),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Within Free Allowance — No Excess Fee!',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],
          _SummaryRow(
            icon: Icons.scale_outlined,
            label: 'Excess Baggage Weight',
            value: AppFormatters.weightKg(estimate.excessWeightKg),
            valueKey: const Key('excessWeightValue'),
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            icon: Icons.payments_outlined,
            label: 'Excess Baggage Charge',
            value: AppFormatters.ringgit(estimate.excessCharge),
            valueKey: const Key('excessChargeValue'),
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            icon: Icons.percent_rounded,
            label: 'Service Tax (8%)',
            value: AppFormatters.ringgit(estimate.serviceTax),
            muted: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Divider(),
          ),
          Text(
            'Total Amount Payable',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.navy.withValues(alpha: 0.65),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppFormatters.ringgit(estimate.totalPayable),
            key: const Key('totalPayableValue'),
            style: const TextStyle(
              fontSize: 34,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: AppColors.navy.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 5),
              Text(
                'Includes 8% service tax',
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppColors.navy.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueKey,
    this.muted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Key? valueKey;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: muted ? AppColors.secondary : AppColors.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.navy.withValues(alpha: muted ? 0.55 : 0.72),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          key: valueKey,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.navy.withValues(alpha: muted ? 0.7 : 1),
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

/// Allows digits and a single decimal point with at most two decimal places.
///
/// Non-numeric and negative input is therefore blocked before it ever reaches
/// the validator, while the validator still protects programmatic input.
class _DecimalTextInputFormatter extends TextInputFormatter {
  const _DecimalTextInputFormatter();

  static final RegExp _pattern = RegExp(r'^\d*\.?\d{0,2}$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty || _pattern.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
