import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/lakon.dart';
import 'package:myportofolio_mobile/screens/lakon_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class LakonListScreen extends StatefulWidget {
  const LakonListScreen({super.key});

  @override
  State<LakonListScreen> createState() => _LakonListScreenState();
}

class _LakonListScreenState extends State<LakonListScreen> {
  late Future<List<Lakon>> _lakonsFuture;

  @override
  void initState() {
    super.initState();
    _lakonsFuture = context.read<ApiClient>().getLakons();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getLakons();
    setState(() {
      _lakonsFuture = future;
    });
    try {
      await future;
    } on Exception {
      // Error ditampilkan oleh FutureBuilder; cukup akhiri animasi refresh.
    }
  }

  String _errorMessage(Object? error) {
    if (error is ApiException) {
      return 'Server membalas dengan error (${error.statusCode}).';
    }
    return 'Tidak dapat terhubung ke server.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lakoni'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Lakon>>(
        future: _lakonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gagal memuat data. ${_errorMessage(snapshot.error)}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final lakons = snapshot.data ?? const <Lakon>[];

          if (lakons.isEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return RefreshIndicator(
                  onRefresh: _reload,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: const Center(child: Text('Belum ada lakon.')),
                    ),
                  ),
                );
              },
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: lakons.length,
              itemBuilder: (context, index) {
                final lakon = lakons[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      lakon.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(lakon.categoryDisplay),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text('${lakon.starCount}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LakonDetailScreen(lakon: lakon),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
