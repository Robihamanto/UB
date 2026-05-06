// ─────────────────────────────────────────────────────────────
//  STEP 5 — COMPLETE: all widgets + FeatureCards + BottomNav
//  This is identical in structure to showroom.dart
//  Run: flutter run -t showroom5.dart
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

// ── Page (stateful for bottom-nav) ────────────────────────────
class _Page extends StatefulWidget {
  const _Page();
  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  int _nav = 0;
  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // TopBar
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
            // Scrollable body
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
                    const SizedBox(height: 10),
                    // ── NEW: FeatureCardRow ──────────────────────
                    _FeatureCardRow(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // ── NEW: BottomNavBar ────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF202020),
                border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
              ),
              padding: EdgeInsets.only(
                top: 10,
                bottom: bottomPad > 0 ? bottomPad : 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(icon: Icons.dashboard_rounded, label: 'Status', selected: _nav == 0, onTap: () => setState(() => _nav = 0)),
                  _NavItem(icon: Icons.map_outlined, label: 'Map', selected: _nav == 1, onTap: () => setState(() => _nav = 1)),
                  _NavItem(icon: Icons.language_rounded, label: 'Services', selected: _nav == 2, onTap: () => setState(() => _nav = 2)),
                  _NavItem(icon: Icons.person_outline_rounded, label: 'Profile', selected: _nav == 3, onTap: () => setState(() => _nav = 3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── HeroCard ──────────────────────────────────────────────────
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

// ── ChargeStatCard ────────────────────────────────────────────
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

// ── QuickActionRow ────────────────────────────────────────────
class _QuickActionRow extends StatelessWidget {
  static const _icons = [
    Icons.lock_outline_rounded, Icons.lock_open_rounded,
    Icons.light_mode_outlined, Icons.volume_up_outlined, Icons.air_rounded,
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

// ── NEW: FeatureCardRow ───────────────────────────────────────
class _FeatureCardRow extends StatelessWidget {
  static const _cards = [
    {'icon': Icons.location_on_outlined, 'title': 'Vehicle Finder', 'sub': 'Karl-Dompert-Straße 7,\n84130 Dingolfing'},
    {'icon': Icons.camera_alt_outlined, 'title': 'Remote Cameras', 'sub': 'Remote 3D and Remote\nInside View'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_cards.length, (i) {
          final c = _cards[i];
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i == 0 ? 10 : 0),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: const Color(0xFF252525), borderRadius: BorderRadius.circular(18)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(c['icon'] as IconData, color: Colors.white70, size: 26),
                const SizedBox(height: 12),
                Text(c['title'] as String,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 6),
                Text(c['sub'] as String,
                    style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.5)),
              ]),
            ),
          );
        }),
      ),
    );
  }
}

// ── NEW: NavItem ──────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: selected ? Colors.white : Colors.white38, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white38,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              )),
        ]),
      ),
    );
  }
}
