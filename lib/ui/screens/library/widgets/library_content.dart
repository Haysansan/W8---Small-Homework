import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';
import '../../../widgets/song/song_tile.dart';
import '../view_model/library_view_model.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 1- Read the globbal song repository
    final vm = context.watch<LibraryViewModel>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text("Library", style: AppTextStyles.heading),
          SizedBox(height: 50),
      
          Expanded(
            child: _buildBody(context, vm),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, LibraryViewModel vm) {
    switch (vm.status) {
      case SongsStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case SongsStatus.error: // error n retry
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              Text(
                vm.errorMessage ?? 'Something went wrong.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );

      case SongsStatus.success: // if success render the song list
        return ListView.builder(
          itemCount: vm.songs.length,
          itemBuilder: (context, index) => SongTile(
            song: vm.songs[index],
            isPlaying: vm.isSongPlaying(vm.songs[index]),
            onTap: () => vm.start(vm.songs[index]),
          ),
        );
    }

  }
}
