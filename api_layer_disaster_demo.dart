import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// DEMO: The "API & UI Spaghetti" Disaster
/// 
/// Why this is a "Disaster" (Bencana):
/// 1. Tightly Coupled: You can't test the logic without rendering the UI.
/// 2. Code Duplication: Every widget needing this data must rewrite the fetch logic.
/// 3. Performance: It's easy to accidentally re-trigger API calls on every rebuild.
/// 4. Maintenance: Changing the API endpoint means hunting through dozens of UI files.
/// 5. Error Handling: Often neglected or inconsistently implemented across widgets.

void main() {
  runApp(const MaterialApp(
    home: DisasterShowcasePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class DisasterShowcasePage extends StatefulWidget {
  const DisasterShowcasePage({super.key});

  @override
  State<DisasterShowcasePage> createState() => _DisasterShowcasePageState();
}

class _DisasterShowcasePageState extends State<DisasterShowcasePage> {
  bool _showDisaster = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showDisaster ? 'Disaster: UI + API Mixed' : 'Better: UI & Logic Separated'),
        actions: [
          Switch(
            value: !_showDisaster,
            onChanged: (val) => setState(() => _showDisaster = !val),
            activeColor: Colors.greenAccent,
          ),
        ],
      ),
      body: _showDisaster ? const SpaghettiWidget() : const CleanWidget(),
    );
  }
}

// =============================================================================
// THE DISASTER (SPAGHETTI) WIDGET
// =============================================================================
class SpaghettiWidget extends StatefulWidget {
  const SpaghettiWidget({super.key});

  @override
  State<SpaghettiWidget> createState() => _SpaghettiWidgetState();
}

class _SpaghettiWidgetState extends State<SpaghettiWidget> {
  // 🚩 PROBLEM 1: Hardcoding state variables inside the widget
  List<dynamic>? _data;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // 🚩 PROBLEM 2: Direct API query mixed with UI logic
  // This is hard to unit test and reusable.
  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 🚩 PROBLEM 3: Hardcoded URLs and raw HTTP calls
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      
      if (response.statusCode == 200) {
        // 🚩 PROBLEM 4: Manual JSON parsing inside the widget
        setState(() {
          _data = json.decode(response.body);
          _loading = false;
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '❌ EVERYTHING IS HERE:\nAPI URL, JSON Parsing, State Management, and UI Rendering all in one 100-line file.',
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text('Error: $_error'))
                  : ListView.builder(
                      itemCount: _data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = _data![index];
                        return ListTile(
                          title: Text(item['title'] ?? 'No Title'), // 🚩 No Model: Using Map keys directly
                          subtitle: Text(item['body'] ?? '', maxLines: 1),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

// =============================================================================
// THE CLEAN (SEPARATED) WIDGET
// =============================================================================

// 1. DATA MODEL: Type-safe and structured
class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

// 2. SERVICE/REPOSITORY: Logic is independent of UI
class PostService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$_baseUrl/posts'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((j) => Post.fromJson(j)).toList();
    } else {
      throw Exception('Server Error: ${response.statusCode}');
    }
  }
}

// 3. UI: Only focuses on "How it looks"
class CleanWidget extends StatelessWidget {
  const CleanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '✅ CLEAN SEPARATION:\nWidget doesn\'t know about URLs or JSON keys. It only deals with Models and Futures/Providers.',
            style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Post>>(
            future: PostService().fetchPosts(), // In real app, use a Provider/StateNotifier
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong!'));
              }
              final posts = snapshot.data ?? [];
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return ListTile(
                    title: Text(post.title), // Type-safe property access
                    subtitle: Text(post.body, maxLines: 1),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
