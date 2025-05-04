import 'package:flutter/material.dart';
import 'package:musicapp/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('F A V O R I T E S'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final favoriteSongs = value.favoriteSongs.map((index) => value.playlist[index]).toList();

          if (favoriteSongs.isEmpty) {
            return const Center(
              child: Text(
                'No favorites yet!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteSongs.length,
            itemBuilder: (context, index) {
              final song = favoriteSongs[index];
              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      song.albumArtImagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}