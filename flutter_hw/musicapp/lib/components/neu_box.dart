import 'package:flutter/material.dart';
import 'package:musicapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class NeuBox extends StatelessWidget {
  final Widget? child;

  const NeuBox({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black : Colors.grey.shade500,
            offset: const Offset(4, 4),
            blurRadius: 15,
          ),
          BoxShadow(
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            offset: const Offset(-4, -4),
            blurRadius: 15,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}