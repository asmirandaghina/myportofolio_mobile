import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/lakon.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class LakonFormPage extends StatefulWidget {
  const LakonFormPage({super.key});

  @override
  State<LakonFormPage> createState() => _LakonFormPageState();
}

class _LakonFormPageState extends State<LakonFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _category = 'seni';
  String _photo = '';
  bool _isSubmitting = false;

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = '';
      _category = 'seni';
      _photo = '';
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final apiClient = context.read<ApiClient>();
    final authState = context.read<AuthState>();
    final messenger = ScaffoldMessenger.of(context);

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;
    final token = authState.token;
    if (token == null) return;

    final newLakon = Lakon(
      title: _title.trim(),
      category: _category,
      photo: _photo.trim(),
    );

    setState(() {
      _isSubmitting = true;
    });
    try {
      final created = await apiClient.createLakon(newLakon, token: token);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Lakon berhasil ditambahkan!'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama: ${created.title}'),
                  Text('Kategori: ${created.categoryDisplay}'),
                  Text('Foto: ${created.photo.isEmpty ? "-" : created.photo}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
      if (!mounted) return;
      _resetForm();
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await authState.logout();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Sesi berakhir. Silakan login kembali.'),
          ),
        );
        if (!mounted) return;
        await ensureLoggedIn(context);
      } else if (e.statusCode == 403) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Hanya superuser yang boleh menambah lakon (403).'),
          ),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text('Gagal menyimpan (${e.statusCode}).')),
        );
      }
    } on Exception {
      messenger.showSnackBar(
        const SnackBar(content: Text('Tidak dapat terhubung ke server.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Tambah Lakon')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nama kegiatan',
                    labelText: 'Nama Kegiatan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _title = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama kegiatan tidak boleh kosong!';
                    }
                    if (value.trim().length > 100) {
                      return 'Nama kegiatan maksimal 100 karakter!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: lakonCategories.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _category = value;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'img/lakoni/kalimba.jpg (opsional)',
                    labelText: 'Foto (Opsional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _photo = value,
                  validator: (value) {
                    if (value != null && value.trim().length > 255) {
                      return 'Path foto maksimal 255 karakter!';
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Simpan',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
