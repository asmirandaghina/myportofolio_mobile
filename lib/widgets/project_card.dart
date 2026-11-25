import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/lakon_form.dart';
import 'package:myportofolio_mobile/screens/lakon_list_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  Future<void> _handleTap(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final authState = context.read<AuthState>();

    if (item.name == 'Logout') {
      final wasLoggedIn = authState.isLoggedIn;
      if (wasLoggedIn) {
        await authState.logout();
      }
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              wasLoggedIn ? 'Kamu berhasil logout.' : 'Kamu belum login.',
            ),
          ),
        );
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Kamu telah menekan tombol ${item.name}!')),
      );

    if (item.name == 'Lihat Lakoni') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LakonListScreen()),
      );
    }
    if (item.name == 'Tambah Item') {
      final loggedIn = await ensureLoggedIn(context);
      if (!loggedIn || !context.mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LakonFormPage()),
      );
    }
    if (item.name == 'Tambah Pengalaman') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExperienceFormPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
