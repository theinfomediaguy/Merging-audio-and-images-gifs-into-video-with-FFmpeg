import 'package:flutter/cupertino.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_music/common/constants.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';

class MergeProvider with ChangeNotifier {
  bool loading = false, isPlaying = false;
  dynamic limit = 10;
  late double startTime = 0, endTime = 10;

  // late VideoPlayerController controller =
  //     VideoPlayerController.asset(Constants.OUTPUT_PATH);

  final Trimmer trimmer = Trimmer();

  void setTimeLimit(dynamic value) async {
    limit = value;
    // await player.setAsset(Constants.AUDIO_PATH);
    // await player.setClip(start: Duration(seconds: 10), end: Duration(seconds: 20));
    notifyListeners();
  }

  void setStartEndTime(int _inputType, double inputValue) {
    _inputType == 0 ? startTime = inputValue : endTime = inputValue;
    notifyListeners();
  }

  void setPlayPause(bool playing) {
    isPlaying = playing;
    notifyListeners();
  }

  Future<void> videoOutput() async {
    loading = true;
    notifyListeners();
    String _commandToExecute =
        '-r 15 -f mp3 -i ${Constants.AUDIO_PATH} -f image2 -i ${Constants.IMAGE_PATH} -pix_fmt yuv420p -y ${Constants.OUTPUT_PATH}';

    await trimmer
        .saveTrimmedVideo(
            startValue: startTime,
            endValue: endTime,
            customVideoFormat: '.mp4')
        .then((value) {
          print(value);
          loading = false;
          notifyListeners();
    });
  }

  Future<void> videoMerger() async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    loading = true;
    String timeLimit = '00:00:';
    notifyListeners();

    if (await Permission.storage.request().isGranted) {
      if (limit.toInt() < 10)
        timeLimit = timeLimit + '0' + limit.toString();
      else
        timeLimit = timeLimit + limit.toString();

      String commandToExecute =
          '-r 15 -f mp3 -i ${Constants.AUDIO_PATH} -f image2 -i ${Constants.IMAGE_PATH} -pix_fmt yuv420p -t $timeLimit -y ${Constants.OUTPUT_PATH}';

      // String commandToExecute = '-r 15 -f mp3 -i ${Constants
      //     .AUDIO_PATH} -f gif -re -stream_loop 5 -i ${Constants.GIF_PATH} -y ${Constants
      //     .OUTPUT_PATH}';
      // String commandToExecute = '-r 30 -pattern_type sequence -start_number 01 -f image2 -i ${Constants
      //     .IMAGES_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      await _flutterFFmpeg.execute(commandToExecute).then((rc) {
        loading = false;
        notifyListeners();
        print('FFmpeg process exited with rc: $rc');
        // controller = VideoPlayerController.asset(Constants.OUTPUT_PATH)
        //   ..initialize().then((_) {
        //     notifyListeners();
        //   });
      });
    } else if (await Permission.storage.isPermanentlyDenied) {
      loading = false;
      notifyListeners();
      openAppSettings();
    }
  }
}
