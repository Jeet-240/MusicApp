import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/widgets/music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    if (currentSong == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          PageRouteBuilder(pageBuilder: (context , animation , secondaryAnimation){
            return const MusicPlayer();
          },
            transitionsBuilder: (context, animation, secondaryAnimation ,child){
                final tween = Tween(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeIn));
                final offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation , child: child);
            }
          ),
        );
      },
      child: Stack(
        children: [
          Hero(
            tag: 'music-image',
            child: Container(
              width: MediaQuery.of(context).size.width - 16,
              height: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: hexToColor(currentSong.hex_code),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          top: 4.0,
                          bottom: 4.0,
                        ),
                        child: Container(
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(currentSong.thumbnail_url),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Pallete.subtitleText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_border,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          songNotifier.playPause();
                        },
                        icon: Icon(
                            songNotifier.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Pallete.whiteColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: songNotifier.audioPlayer?.positionStream,
            builder: (context , snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const SizedBox();
              }
              final position = snapshot.data;
              final duration = songNotifier.audioPlayer?.duration;
              double sliderValue = 0.0;
              if(position != null && duration != null){
              sliderValue = position.inMicroseconds/duration.inMicroseconds;
              }
              return Positioned(
                left: 8,
                bottom: 0,
                child: Container(
                  height: 2,
                  width: sliderValue * (MediaQuery.of(context).size.width - 32),
                  decoration: const BoxDecoration(color: Pallete.whiteColor),
                ),
              );
            },
          ),
          Positioned(
            left: 8,
            bottom: 0,
            child: Container(
              height: 2,
              width: (MediaQuery.of(context).size.width - 32),
              decoration: BoxDecoration(
                color: Pallete.inactiveSeekColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
