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
  final List<int> _favoriteSongs = [];

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  bool _isShuffle = false;
  bool _isRepeat = false;

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
      if (_isShuffle) {
        _currentSongIndex = (List.generate(_playlist.length, (i) => i)..shuffle()).first;
      } else if (_currentSongIndex! < _playlist.length - 1) {
        _currentSongIndex = _currentSongIndex! + 1;
      } else {
        return;
      }
      play();
    }
  }

  void playPreviousSong() {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_isShuffle) {
        _currentSongIndex = (List.generate(_playlist.length, (i) => i)..shuffle()).first;
      } else if (_currentSongIndex! > 0) {
        _currentSongIndex = _currentSongIndex! - 1;
      } else {
        return; 
      }
      play();
    }
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  void toggleFavorite(int songIndex) {
    if (_favoriteSongs.contains(songIndex)) {
      _favoriteSongs.remove(songIndex); 
    } else {
      _favoriteSongs.add(songIndex);
    }
    notifyListeners();
  }

  bool isFavorite(int songIndex) {
    return _favoriteSongs.contains(songIndex);
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
      if (_isRepeat) {
        if (_currentSongIndex != null) {
          _currentSongIndex = _currentSongIndex; 
          play();
        }
      } else {
        playNextSong();
      }
    });
  }

  // Getters
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  List<int> get favoriteSongs => _favoriteSongs;

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
