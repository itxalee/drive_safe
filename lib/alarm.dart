import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class Alarm {
  late final String filename;
  late final AudioPlayer _audioPlayer;

  Alarm(this.filename);

  Future<void> init() async {
    _audioPlayer = await AudioCache().play(filename);
    _audioPlayer.stop();
  }

  // void initState() async {
  //   _audioPlayer = await AudioCache().play(filePath);
  //   _audioPlayer.stop();
  //   super.initState();
  // }

  Future<void> dispose() => Future.wait([
        _audioPlayer.dispose(),
      ]);

  Future<void> play() async {
    _audioPlayer.resume();
  }

  Future<void> stop() async {
    _audioPlayer.stop();
  }
}
