import 'package:flutter/material.dart';

/// DEMO: Decoupling UI From Logic
/// 
/// Concept:
/// 1. The "Dumb" View (Layar Bodoh): UI doesn't know about APIs, databases, or logic.
///    It only knows how to display what it's given and notify when a button is clicked.
/// 
/// 2. The "State" Brain (Otak State): The logic layer that coordinates data fetching,
///    error handling, and state transitions. It feeds the UI.

void main() {
  runApp(const MaterialApp(
    home: DecouplingDemoPage(),
    debugShowCheckedModeBanner: false,
  ));
}

// ══════════════════════════════════════════════════════════════════════════════
//  1. THE DATA MODEL
// ══════════════════════════════════════════════════════════════════════════════
class Movie {
  final String title;
  final String genre;
  Movie({required this.title, required this.genre});
}

// ══════════════════════════════════════════════════════════════════════════════
//  2. THE "STATE" BRAIN (Controller / ViewModel)
//  Tugas: Handle API, logic, rules, and update data.
// ══════════════════════════════════════════════════════════════════════════════
class MovieController extends ValueNotifier<AsyncSnapshot<List<Movie>>> {
  MovieController() : super(const AsyncSnapshot.nothing());

  // Simulating an API call
  Future<void> loadMovies() async {
    value = const AsyncSnapshot.waiting();
    
    await Future.delayed(const Duration(seconds: 2)); // Artificial delay
    
    // Randomly succeed or fail to show logic handling
    final success = DateTime.now().second % 2 == 0; 
    
    if (success) {
      final data = [
        Movie(title: 'Inception', genre: 'Sci-Fi'),
        Movie(title: 'The Dark Knight', genre: 'Action'),
        Movie(title: 'Interstellar', genre: 'Sci-Fi'),
      ];
      value = AsyncSnapshot.withData(ConnectionState.done, data);
    } else {
      value = AsyncSnapshot.withError(ConnectionState.done, 'Failed to fetch movies. Try again!');
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  3. THE "DUMB" VIEW (UI Component)
//  Tugas: Hanya menampilkan data. Tidak ada 'fetch' atau 'logic' di sini.
// ══════════════════════════════════════════════════════════════════════════════
class DumbMovieView extends StatelessWidget {
  final AsyncSnapshot<List<Movie>> state;
  final VoidCallback onRefresh;

  const DumbMovieView({
    super.key, 
    required this.state, 
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // 🚩 UI is "stupid" - it just reacts to the 'state' object
    if (state.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('❌ ${state.error}', style: const TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: onRefresh, child: const Text('Retry')),
          ],
        ),
      );
    }

    final movies = state.data ?? [];
    if (movies.isEmpty) {
      return const Center(child: Text('No movies found. Tap refresh.'));
    }

    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.movie_outlined),
          title: Text(movies[index].title),
          subtitle: Text(movies[index].genre),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  4. THE CONNECTOR (Page)
//  Connects the Brain with the Dumb View.
// ══════════════════════════════════════════════════════════════════════════════
class DecouplingDemoPage extends StatefulWidget {
  const DecouplingDemoPage({super.key});

  @override
  State<DecouplingDemoPage> createState() => _DecouplingDemoPageState();
}

class _DecouplingDemoPageState extends State<DecouplingDemoPage> {
  // Initialize the "Brain"
  final MovieController _brain = MovieController();

  @override
  void initState() {
    super.initState();
    _brain.loadMovies(); // Trigger initial load
  }

  @override
  void dispose() {
    _brain.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI & Logic Decoupled'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _brain.loadMovies(),
          ),
        ],
      ),
      // Use ValueListenableBuilder to rebuild only the Dumb View when Brain updates
      body: ValueListenableBuilder<AsyncSnapshot<List<Movie>>>(
        valueListenable: _brain,
        builder: (context, state, _) {
          return DumbMovieView(
            state: state, 
            onRefresh: () => _brain.loadMovies(),
          );
        },
      ),
    );
  }
}
