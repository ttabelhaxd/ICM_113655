import 'package:flutter/material.dart';
import 'package:musicapp/components/neu_box.dart';
import 'package:musicapp/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        final playlist = value.playlist;
        final currentSong = playlist[value.currentSongIndex ?? 0];

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),

                      const Text(
                        'P L A Y L I S T',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'favorite') {
                            Provider.of<PlaylistProvider>(
                              context,
                              listen: false,
                            ).toggleFavorite(
                              Provider.of<PlaylistProvider>(
                                    context,
                                    listen: false,
                                  ).currentSongIndex ??
                                  0,
                            );
                          } else if (value == 'share') { 
                            //TODO                                                       
                          } else if (value == 'details') {
                            // Exibir detalhes da música
                            final currentSong =
                                Provider.of<PlaylistProvider>(
                                  context,
                                  listen: false,
                                ).playlist[Provider.of<PlaylistProvider>(
                                      context,
                                      listen: false,
                                    ).currentSongIndex ??
                                    0];
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text(currentSong.songName),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Artist: ${currentSong.artistName}\nAlbum:',
                                        ),
                                        const SizedBox(height: 10),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.asset(
                                            currentSong.albumArtImagePath,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                            );
                          }
                        },
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
                                value: 'favorite',
                                child: Text('Add/Remove Favorite'),
                              ),
                              const PopupMenuItem(
                                value: 'share',
                                child: Text('Share Song'),
                              ),
                              const PopupMenuItem(
                                value: 'details',
                                child: Text('Song Details'),
                              ),
                            ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  NeuBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            currentSong.albumArtImagePath,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentSong.songName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      currentSong.artistName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                icon: Icon(
                                  value.isFavorite(value.currentSongIndex ?? 0)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  value.toggleFavorite(
                                    value.currentSongIndex ?? 0,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatTime(value.currentDuration)),
                            IconButton(
                              icon: Icon(
                                Icons.shuffle,
                                color:
                                    value.isShuffle
                                        ? Colors.green
                                        : Colors.grey,
                              ),
                              onPressed: () {
                                value.toggleShuffle();
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.repeat,
                                color:
                                    value.isRepeat ? Colors.green : Colors.grey,
                              ),
                              onPressed: () {
                                value.toggleRepeat();
                              },
                            ),
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),
                      ),

                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 0,
                          ),
                        ),
                        child: Slider(
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          value: value.currentDuration.inSeconds.toDouble(),
                          activeColor: Colors.green,
                          onChanged: (double double) {},
                          onChangeEnd: (double double) {
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: value.playPreviousSong,
                              child: const NeuBox(
                                child: Icon(Icons.skip_previous),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: value.pauseOrResume,
                              child: NeuBox(
                                child: Icon(
                                  value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            child: GestureDetector(
                              onTap: value.playNextSong,
                              child: const NeuBox(child: Icon(Icons.skip_next)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
