// ─────────────────────────────────────────────────────────────
//  STEP 4 — TopBar + HeroCard + ChargeStatCard + QuickActions
//  Run: flutter run -t showroom4.dart
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.notifications_none_rounded, color: Colors.white70, size: 26),
                  Text('iX xDrive50',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  Icon(Icons.directions_car_outlined, color: Colors.white70, size: 26),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    _HeroCard(),
                    const SizedBox(height: 10),
                    _ChargeStatCard(),
                    const SizedBox(height: 10),
                    _QuickActionRow(),
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color(0xFF2B2B2B)),
      clipBehavior: Clip.antiAlias,
      child: Stack(fit: StackFit.expand, children: [
        Positioned(
          right: -20, bottom: 0, top: 0,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Image.network(
            'https://picsum.photos/seed/car-hero/500/300',
            fit: BoxFit.cover,
            color: Colors.white.withOpacity(0.15),
            colorBlendMode: BlendMode.srcOver,
            errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, color: Colors.white24, size: 80),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              stops: [0.0, 0.55, 1.0],
              colors: [Color(0xFF2B2B2B), Color(0xCC2B2B2B), Color(0x002B2B2B)],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Check Status', style: TextStyle(color: Colors.white60, fontSize: 13)),
              SizedBox(height: 8),
              Text('ALL\nGOOD',
                  style: TextStyle(color: Colors.white, fontSize: 54,
                      fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -1.5)),
              Spacer(),
              Text('Updated from vehicle on 5/6/2026 at 10:00 PM',
                  style: TextStyle(color: Colors.white54, fontSize: 11.5)),
            ],
          ),
        ),
      ]),
    );
  }
}

class _ChargeStatCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(color: const Color(0xFF252525), borderRadius: BorderRadius.circular(18)),
      child: Column(children: [
        Row(children: const [
          Icon(Icons.battery_charging_full_rounded, color: Colors.white70, size: 22),
          SizedBox(width: 10),
          Text('State of Charge', style: TextStyle(color: Colors.white70, fontSize: 14)),
          Spacer(),
          Text('100 %', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text('/', style: TextStyle(color: Colors.white38, fontSize: 20)),
          ),
          Text('556 km', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: const LinearProgressIndicator(
            value: 1.0,
            backgroundColor: Color(0x22FFFFFF),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          ),
        ),
      ]),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  static const _icons = [
    Icons.lock_outline_rounded,
    Icons.lock_open_rounded,
    Icons.light_mode_outlined,
    Icons.volume_up_outlined,
    Icons.air_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(color: const Color(0xFF252525), borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _icons.map((ic) => _ActionBtn(icon: ic)).toList(),
      ),
    );
  }
}

class _ActionBtn extends StatefulWidget {
  final IconData icon;
  const _ActionBtn({required this.icon});
  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 52, height: 52,
        decoration: BoxDecoration(
          color: _pressed ? const Color(0xFF3A3A3A) : const Color(0xFF2E2E2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(widget.icon, color: Colors.white70, size: 24),
      ),
    );
  }
}
