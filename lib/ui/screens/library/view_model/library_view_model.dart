import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
enum SongsStatus { loading, success, error }

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;
  SongsStatus status = SongsStatus.loading;
  List<Song> songs = [];
  String? errorMessage;

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  // List<Song> get songs => _songs == null ? [] : _songs!;

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    // 1 - Fetch songs
    status = SongsStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      songs = await songRepository.fetchSongs();
      status = SongsStatus.success;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      status = SongsStatus.error;
    }

    // 2 - notify listeners
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
