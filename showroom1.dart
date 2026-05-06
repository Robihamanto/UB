// ─────────────────────────────────────────────────────────────
//  STEP 1 — Dark scaffold + TopBar
//  Run: flutter run -t showroom1.dart
// ─────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1C1C1C),
          useMaterial3: true,
        ),
        home: const _Page(),
      );
}

class _Page extends StatelessWidget {
  const _Page();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: Column(
          children: [
            // ── TopBar ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.notifications_none_rounded,
                      color: Colors.white70, size: 26),
                  Text(
                    'iX xDrive50',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                  Icon(Icons.directions_car_outlined,
                      color: Colors.white70, size: 26),
                ],
              ),
            ),
            // ── Body placeholder ──────────────────────────────────
            const Expanded(
              child: Center(
                child: Text('Step 1 — TopBar ✓',
                    style: TextStyle(color: Colors.white38)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
