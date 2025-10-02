import 'package:shadcn_flutter/shadcn_flutter.dart';

class ShadcnBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ShadcnBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<ShadcnBottomNav> createState() => _ShadcnBottomNavState();
}

class _ShadcnBottomNavState extends State<ShadcnBottomNav> {
  int selected = 0;
  NavigationBarAlignment alignment = NavigationBarAlignment.spaceAround;
  NavigationLabelType labelType = NavigationLabelType.none;
  bool customButtonStyle = true;
  bool expanded = true;
  bool expands = true;

  NavigationItem buildButton(String label, IconData icon) {
    return NavigationItem(
      style: customButtonStyle
          ? const ButtonStyle.muted(density: ButtonDensity.icon)
          : null,
      selectedStyle: customButtonStyle
          ? const ButtonStyle.fixed(density: ButtonDensity.icon)
          : null,
      label: Text(label),
      child: Icon(icon),
    );
  }

  @override
  void initState() {
    super.initState();
    selected = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      alignment: alignment,
      labelType: labelType,
      expanded: expanded,
      expands: expands,
      index: selected,
      onSelected: (index) {
        setState(() => selected = index);
        widget.onTap(index);
      },
      children: [
        buildButton('Home', Icons.home),
        buildButton('Favorite', Icons.favorite),
        buildButton('Settings', Icons.settings),
      ],
    );
  }
}
