import 'package:flutter/material.dart';

import 'screens/about_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/app_logo.dart';

void main() => runApp(const AirBaggageApp());

class AirBaggageApp extends StatelessWidget {
  const AirBaggageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AirBaggage Fee Estimator',
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  void _selectDestination(int index) {
    if (index == _selectedIndex) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isHome = _selectedIndex == 0;

    return PopScope(
      canPop: isHome,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !isHome) {
          _selectDestination(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const AppLogo(size: 38),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AirBaggage Fee Estimator',
                      key: Key('appBarTitle'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.surface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      isHome ? 'Excess baggage made simple' : 'About this app',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.surface.withValues(alpha: 0.7),
                        letterSpacing: 0.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            if (isHome)
              IconButton(
                key: const Key('appBarAboutButton'),
                tooltip: 'About this app',
                onPressed: () => _selectDestination(1),
                icon: const Icon(Icons.info_outline_rounded),
              ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: const _AppBarSkyline(),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: const [HomeScreen(), AboutScreen()],
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(
                color: AppColors.secondary.withValues(alpha: 0.45),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectDestination,
            destinations: const [
              NavigationDestination(
                key: Key('navHome'),
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                key: Key('navAbout'),
                icon: Icon(Icons.info_outline_rounded),
                selectedIcon: Icon(Icons.info_rounded),
                label: 'About',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A very subtle aviation motif painted behind the app bar content.
class _AppBarSkyline extends StatelessWidget {
  const _AppBarSkyline();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: -24,
              top: -20,
              child: Transform.rotate(
                angle: -0.28,
                child: Icon(
                  Icons.flight_rounded,
                  size: 124,
                  color: AppColors.surface.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              left: -18,
              bottom: -46,
              child: Icon(
                Icons.cloud_rounded,
                size: 112,
                color: AppColors.surface.withValues(alpha: 0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
