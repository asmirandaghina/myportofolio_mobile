import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/lakon.dart';

class LakonDetailScreen extends StatelessWidget {
  const LakonDetailScreen({required this.lakon, super.key});

  final Lakon lakon;

  /// photo di Django berupa path relatif, jadi disusun menjadi URL static.
  String _imageUrl(String photo) {
    if (photo.startsWith('http')) return photo;
    final path = photo.startsWith('/') ? photo.substring(1) : photo;
    return '$apiBaseUrl/static/$path';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(lakon.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widget gambar hanya tampil kalau photo tidak kosong.
            if (lakon.photo.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _imageUrl(lakon.photo),
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 220,
                      child: Center(child: Icon(Icons.broken_image, size: 48)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              lakon.title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('Kategori', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(lakon.categoryDisplay),
            const SizedBox(height: 16),
            Text('Bintang', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('${lakon.starCount}'),
            if (lakon.starredByNames.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Diberi bintang oleh', style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(lakon.starredByNames),
            ],
          ],
        ),
      ),
    );
  }
}
