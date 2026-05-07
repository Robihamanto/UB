import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Mastering the Scrollable Feed
//
//  ❌ Column: builds ALL 100 items at once — jank, then crash at scale.
//  ✅ ListView.builder: lazy loading — only visible items are built (~5–10
//     tiles in memory at a time), keeps 60-120 fps with thousands of entries.
// ─────────────────────────────────────────────────────────────────────────────

void main() => runApp(const ScrollableFeedApp());

// ── App root ──────────────────────────────────────────────────────────────────

class ScrollableFeedApp extends StatelessWidget {
  const ScrollableFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrollable Feed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1C1C),
        useMaterial3: true,
      ),
      home: const ScrollableFeedPage(),
    );
  }
}

// ── Mock data ─────────────────────────────────────────────────────────────────

class _FeedItem {
  final int id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  const _FeedItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });
}

final List<_FeedItem> _items = List.generate(1000, (i) {
  const icons = [
    Icons.movie_outlined,
    Icons.star_outline_rounded,
    Icons.local_fire_department_outlined,
    Icons.trending_up_rounded,
    Icons.bookmark_outline_rounded,
    Icons.play_circle_outline_rounded,
  ];
  const accents = [
    Color(0xFF6C63FF),
    Color(0xFFFF6584),
    Color(0xFF43CFBC),
    Color(0xFFFFB347),
    Color(0xFF74B9FF),
    Color(0xFFFF7675),
  ];
  return _FeedItem(
    id: i + 1,
    title: 'Item #${i + 1}',
    subtitle: 'Built on demand — index $i',
    icon: icons[i % icons.length],
    accent: accents[i % accents.length],
  );
});

// ── Page ──────────────────────────────────────────────────────────────────────

class ScrollableFeedPage extends StatelessWidget {
  const ScrollableFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        title: const Text('ListView.builder — 1 000 items'),
        centerTitle: true,
      ),

      // ✅ ListView.builder: itemBuilder is called only when an item
      //    scrolls into view. The framework disposes tiles that leave
      //    the viewport, so memory stays flat regardless of list size.
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _items.length,
        // Pre-builds tiles 200 px beyond the visible edge for smooth scrolling.
        cacheExtent: 200,
        itemBuilder: (context, index) => _FeedTile(item: _items[index]),
      ),
    );
  }
}

// ── Tile ──────────────────────────────────────────────────────────────────────

class _FeedTile extends StatelessWidget {
  final _FeedItem item;

  const _FeedTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: item.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.accent, size: 22),
          ),
          const SizedBox(width: 12),
          // Labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          // Index chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '#${item.id}',
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
