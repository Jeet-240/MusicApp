import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
          hexToColor(currentSong!.hex_code),
          const Color(0xff121212),
        ]),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('assets/images/pull-down-arrow.png' , color: Pallete.whiteColor),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Hero(
                  tag: 'music-image',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(currentSong!.thumbnail_url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              color: Pallete.subtitleText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(onPressed: () {

                      }, icon: const Icon(Icons.favorite_border))
                    ],
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder(
                    stream: songNotifier.audioPlayer!.positionStream,
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const SizedBox();
                      }
                      final position = snapshot.data;
                      final duration = songNotifier.audioPlayer!.duration;
                      int positioninSeconds =  snapshot.data!.inSeconds - snapshot.data!.inMinutes * 60;
                      int positioninMinutes = snapshot.data!.inMinutes - snapshot.data!.inHours;
                      int positioninHours = snapshot.data!.inHours;
                      String songDuration = duration!.toHHMMSS()[0] == '0' && duration!.toHHMMSS()[1] == '0' ? duration!.toHHMMSS().substring(3) : duration!.toHHMMSS();

                      double slideValue = 0.0;
                      if(position != null && duration != null){
                        slideValue = position.inMilliseconds/duration.inMilliseconds;
                      }
                      return Column(
                        children: [
                          StatefulBuilder(
                            builder:  (context, setState) {
                              return SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Pallete.whiteColor,
                                    inactiveTrackColor: Pallete.whiteColor.withOpacity(0.117),
                                    thumbColor: Pallete.whiteColor,
                                    trackHeight: 4,
                                    overlayShape: SliderComponentShape.noOverlay
                                ),
                                child: Slider(value: slideValue , min:  0 , max: 1 ,onChanged: (val){
                                  setState(){
                                    slideValue = val;
                                  }
                                },
                                  onChangeEnd: (val){
                                    songNotifier.seek(val);
                                  },
                                ),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${positioninHours == 0 ? '' : '$positioninHours:'}  $positioninMinutes:${positioninSeconds < 10 ? '0$positioninSeconds' : positioninSeconds} ' , style: TextStyle(
                                  color: Pallete.subtitleText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300
                              ),),
                              Text(
                                songDuration,
                                style: TextStyle(
                                    color: Pallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300
                                ),)
                            ],
                          ),
                        ],
                      );
                    },

                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/images/shuffle.png' , color: Pallete.whiteColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/images/previous-song.png' , color: Pallete.whiteColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(onPressed: () {
                            songNotifier.playPause();
                        }, icon: Icon(songNotifier. isPlaying ?  Icons.pause_circle : Icons.play_circle_fill ) , iconSize: 80, color: Pallete.whiteColor,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/images/next-song.png' , color: Pallete.whiteColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/images/repeat.png' , color: Pallete.whiteColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/images/playlist.png' , color: Pallete.whiteColor),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/images/connect-device.png' , color: Pallete.whiteColor),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
