import 'package:flutter/cupertino.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_music/common/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class MergeProvider with ChangeNotifier {
  bool loading = false, isPlaying = false;
  dynamic limit = 10;
  late double startTime = 0, endTime = 10;

  void setTimeLimit(dynamic value) async {
    limit = value;
    notifyListeners();
  }

  Future<void> mergeIntoVideo() async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    loading = true;
    String timeLimit = '00:00:';
    notifyListeners();

    if (await Permission.storage.request().isGranted) {
      if (limit.toInt() < 10)
        timeLimit = timeLimit + '0' + limit.toString();
      else
        timeLimit = timeLimit + limit.toString();

      /// To combine audio with video
      ///
      /// Merging video and audio, with audio re-encoding
      /// -c:v copy -c:a aac
      ///
      /// Copying the audio without re-encoding
      /// -c copy
      ///
      /// Replacing audio stream
      /// -c:v copy -c:a aac -map 0:v:0 -map 1:a:0
      String commandToExecute =
          '-r 15 -f mp4 -i ${Constants.VIDEO_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $timeLimit -y ${Constants.OUTPUT_PATH}';

      /// To combine audio with image
      // String commandToExecute =
      //     '-r 15 -f mp3 -i ${Constants.AUDIO_PATH} -f image2 -i ${Constants.IMAGE_PATH} -pix_fmt yuv420p -t $timeLimit -y ${Constants.OUTPUT_PATH}';

      /// To combine audio with gif
      // String commandToExecute = '-r 15 -f mp3 -i ${Constants
      //     .AUDIO_PATH} -f gif -re -stream_loop 5 -i ${Constants.GIF_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      /// To combine audio with sequence of images
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
