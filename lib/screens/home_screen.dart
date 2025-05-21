import 'package:flutter/material.dart';
import 'add_word_screen.dart';
import 'test_screen.dart';
import 'settings_screen.dart';
import 'report_screen.dart';
import 'wordle_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hoş geldin, $userName!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _HomeButton(
                icon: Icons.add,
                label: 'Kelime Ekle',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddWordScreen()),
                ),
              ),
              _HomeButton(
                icon: Icons.quiz,
                label: 'Sınava Gir',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TestScreen()),
                ),
              ),
              _HomeButton(
                icon: Icons.settings,
                label: 'Ayarlar',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
                ),
              ),
              _HomeButton(
                icon: Icons.bar_chart,
                label: 'Analiz Raporu',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReportScreen()),
                ),
              ),
              _HomeButton(
                icon: Icons.extension,
                label: 'Bulmaca (Wordle)',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WordleScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // İleride diğer sayfalara geçiş için kullanılabilir
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Test'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(icon, size: 24),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(label, style: const TextStyle(fontSize: 18)),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}