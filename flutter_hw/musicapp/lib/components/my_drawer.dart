import 'package:flutter/material.dart';
import 'package:musicapp/pages/favorites_page.dart';
import 'package:musicapp/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // icon
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.music_note,
                size: 50,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          // home tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25),
            child: ListTile(
              title: const Text('H O M E'),
              leading: const Icon(Icons.home),
              onTap: () => {Navigator.pop(context)},
            ),
          ),
          
          // favourites tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 10),
            child: ListTile(
              title: const Text('F A V O R I T E S'),
              leading: const Icon(Icons.favorite),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              },
            ),
          ),

          // settings tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 10),
            child: ListTile(
              title: const Text('S E T T I N G S'),
              leading: const Icon(Icons.settings),
              onTap:
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
            ),
          ),
        ],
      ),
    );
  }
}
