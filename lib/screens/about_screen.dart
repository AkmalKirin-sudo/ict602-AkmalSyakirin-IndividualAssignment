import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String appName = 'AirBaggage Fee Estimator';
  static const String appVersion = '1.0.0';
  static const String authorName = 'MUHAMMAD AKMAL SYAKIRIN BIN MOHD FAISAL';
  static const String matricNo = '2025226096';
  static const String course = 'ICT602 - Mobile Technology and Development';
  static const String githubUrl =
      'https://github.com/akmalsyakirin/excess_baggage_app';

  Future<void> _openRepository(BuildContext context) async {
    try {
      final opened = await launchUrl(
        Uri.parse(githubUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!opened && context.mounted) {
        _showError(context);
      }
    } on Exception {
      if (context.mounted) {
        _showError(context);
      }
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.link_off_rounded,
                size: 19,
                color: AppColors.secondary,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Could not open the GitHub link. Please try again.',
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAppCard(),
                const SizedBox(height: 16),
                _buildAuthorCard(),
                const SizedBox(height: 16),
                _buildRepositoryCard(context),
                const SizedBox(height: 24),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppCard() {
    return AppCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.55),
              ),
            ),
            child: const AppLogo(size: 82),
          ),
          const SizedBox(height: 16),
          const Text(
            appName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
              letterSpacing: -0.4,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Travel light. Fly smart.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.navy.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          const Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoPill(
                icon: Icons.new_releases_outlined,
                label: 'Version $appVersion',
              ),
              _InfoPill(icon: Icons.palette_outlined, label: 'Material 3'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorCard() {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const AppIconBadge(
                  icon: Icons.person_pin_outlined,
                  size: 44,
                  iconSize: 21,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Author Information',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Details of the project author.',
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
          ),
          const Divider(),
          const _AuthorTile(
            icon: Icons.person_outline_rounded,
            label: 'Name',
            value: authorName,
          ),
          Divider(
            indent: 72,
            endIndent: 20,
            color: AppColors.secondary.withValues(alpha: 0.35),
          ),
          const _AuthorTile(
            icon: Icons.badge_outlined,
            label: 'Matric No',
            value: matricNo,
          ),
          Divider(
            indent: 72,
            endIndent: 20,
            color: AppColors.secondary.withValues(alpha: 0.35),
          ),
          const _AuthorTile(
            icon: Icons.school_outlined,
            label: 'Course',
            value: course,
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildRepositoryCard(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: const Key('githubButton'),
            onTap: () => _openRepository(context),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.code_rounded,
                      color: AppColors.surface,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Flexible(
                              child: Text(
                                'GitHub Repository',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.open_in_new_rounded,
                              size: 14,
                              color: AppColors.primary.withValues(alpha: 0.9),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          githubUrl,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to open in your browser',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.navy.withValues(alpha: 0.52),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          '© 2026 $authorName.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: AppColors.navy.withValues(alpha: 0.55),
          ),
        ),
        Text(
          'All Rights Reserved.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: AppColors.navy.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Built with Flutter · Material 3',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: AppColors.navy.withValues(alpha: 0.38),
          ),
        ),
      ],
    );
  }
}

class _AuthorTile extends StatelessWidget {
  const _AuthorTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      minVerticalPadding: 10,
      leading: AppIconBadge(icon: icon, size: 40, iconSize: 19, radius: 10),
      title: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppColors.navy.withValues(alpha: 0.5),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.35,
            color: AppColors.navy,
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
