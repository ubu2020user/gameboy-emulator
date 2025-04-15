import 'dart:io';

// import 'package:wave_generator/wave_generator.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioGenerator {
  static void test() {
    if (Platform.isIOS || Platform.isAndroid) {
      AudioPlayer audioPlayer = AudioPlayer();
      // audioPlayer.play('output.wav');
    }

    testSoundGenerator() async {
      /*WaveGenerator generator = WaveGenerator(*/ /* sample rate */ /* 44100, BitDepth.Depth8bit);

      // Note(frequency, msDuration, waveform, volume);
      Note note = Note(220, 3000, Waveform.Sine, 0.5);
      File file = File('output.wav');

      List<int> bytes = List<int>();
      await for(int byte in generator.generate(note))
      {
        bytes.add(byte);
      }

      file.writeAsBytes(bytes, mode: FileMode.append);
    }

    testSoundGenerator();*/
    }
  }
}
