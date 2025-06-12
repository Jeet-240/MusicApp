import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_pallete.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();
  @override
  void initState() {
    // TODO: implement initState
    initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerController.dispose();
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path);
  }
  
  Future<void> playAndPause() async{
    if(!playerController.playerState.isPlaying){
      await playerController.startPlayer();
    }else if(!playerController.playerState.isPaused){
      await playerController.pausePlayer();
    }
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: (){
          playAndPause();
        }, icon: Icon(
            playerController.playerState.isPlaying ? CupertinoIcons.pause_solid: CupertinoIcons.play_arrow_solid
        )),
        Expanded(
          child: AudioFileWaveforms(
            backgroundColor: Colors.redAccent,
            size: const Size(double.infinity, 100),
            playerController: playerController,
            playerWaveStyle: const PlayerWaveStyle(
              fixedWaveColor: Pallete.borderColor,
              liveWaveColor: Pallete.gradient2,
              spacing: 8,
              showSeekLine: false
            ),
            waveformType: WaveformType.long,
          ),
        ),
      ],
    );
  }
}
