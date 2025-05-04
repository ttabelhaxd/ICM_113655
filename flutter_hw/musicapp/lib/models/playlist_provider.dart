import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: 'Passo Bem Solto',
      artistName: 'ATLXS',
      albumArtImagePath: 'assets/images/a.png',
      audioPath: 'audio/a.mp3',
    ),

    Song(
      songName: 'Pump It',
      artistName: 'DJ GBR',
      albumArtImagePath: 'assets/images/b.png',
      audioPath: 'audio/b.mp3',
    ),

    Song(
      songName: 'Tatuagem da Aranha',
      artistName: 'MC Xenon',
      albumArtImagePath: 'assets/images/c.jpg',
      audioPath: 'audio/c.mp3',
    ),

    Song(
      songName: 'Never Gonna Give You Up',
      artistName: 'Rick Astley',
      albumArtImagePath: 'assets/images/d.png',
      audioPath: 'audio/d.mp3',
    ),

    Song(
      songName: 'The Final Countdown',
      artistName: 'Europe',
      albumArtImagePath: 'assets/images/e.png',
      audioPath: 'audio/e.mp3',
    ),
  ];

  int? _currentSongIndex;

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;

  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        _currentSongIndex = _currentSongIndex! + 1;
      } else {
        _currentSongIndex = 0;
      }
      play();
    }
  }

  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        _currentSongIndex = _currentSongIndex! - 1;
      } else {
        _currentSongIndex = _playlist.length - 1;
      }
      play();
    }
  }

  PlaylistProvider() {
    listenToDuration();
  }

  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // Getters
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  // Setters
  set currentSongIndex(int? index) {
  if (_currentSongIndex == index) return;
  _currentSongIndex = index;

  if (_currentSongIndex != null) {
    play();
  }
  notifyListeners();
}
}
