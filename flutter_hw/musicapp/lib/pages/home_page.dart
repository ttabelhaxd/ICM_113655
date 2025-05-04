import 'package:flutter/material.dart';
import 'package:musicapp/components/my_drawer.dart';
import 'package:musicapp/models/playlist_provider.dart';
import 'package:musicapp/models/song.dart';
import 'package:musicapp/pages/song_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PlaylistProvider playlistProvider;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
  if (playlistProvider.currentSongIndex != songIndex) {
    playlistProvider.currentSongIndex = songIndex;
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SongPage()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('P L A Y L I S T'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Consumer<PlaylistProvider>(
            builder: (context, value, child) {
              if (value.currentSongIndex != null) {
                final currentSong = value.playlist[value.currentSongIndex!];
                return Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          value.isPlaying ? 'Currently Playing - ${currentSong.songName}' : 'Paused - ${currentSong.songName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        icon: value.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                        onPressed: () {
                          value.pauseOrResume();
                        },
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          Expanded(
            child: Consumer<PlaylistProvider>(
              builder: (context, value, child) {
                final List<Song> playlist = value.playlist;

                return ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final Song song = playlist[index];
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
                      onTap: () => goToSong(index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
