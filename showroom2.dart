// ─────────────────────────────────────────────────────────────
//  STEP 2 — TopBar + HeroCard
//  Run: flutter run -t showroom2.dart
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
                        fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.directions_car_outlined,
                      color: Colors.white70, size: 26),
                ],
              ),
            ),
            // ── HeroCard ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    _HeroCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF2B2B2B),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Car image
          Positioned(
            right: -20, bottom: 0, top: 0,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Image.network(
              'https://picsum.photos/seed/car-hero/500/300',
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.15),
              colorBlendMode: BlendMode.srcOver,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.directions_car, color: Colors.white24, size: 80),
            ),
          ),
          // Left gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                stops: [0.0, 0.55, 1.0],
                colors: [Color(0xFF2B2B2B), Color(0xCC2B2B2B), Color(0x002B2B2B)],
              ),
            ),
          ),
          // Text
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Check Status',
                    style: TextStyle(color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 8),
                const Text(
                  'ALL\nGOOD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 54,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -1.5,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Updated from vehicle on 5/6/2026 at 10:00 PM',
                  style: TextStyle(color: Colors.white54, fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
