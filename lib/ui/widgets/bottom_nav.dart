import 'package:shadcn_flutter/shadcn_flutter.dart';

class ShadcnBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ShadcnBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  NavigationItem buildButton(String label, IconData icon) {
    return NavigationItem(
      style: const ButtonStyle.muted(density: ButtonDensity.icon),
      selectedStyle: const ButtonStyle.fixed(density: ButtonDensity.icon),
      label: Text(label),
      child: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      alignment: NavigationBarAlignment.spaceAround,
      labelType: NavigationLabelType.none,
      expanded: true,
      expands: true,
      index: currentIndex,
      onSelected: onTap,
      children: [
        buildButton('Home', Icons.home),
        buildButton('Favorite', Icons.favorite),
        buildButton('Settings', Icons.settings),
      ],
    );
  }
}
