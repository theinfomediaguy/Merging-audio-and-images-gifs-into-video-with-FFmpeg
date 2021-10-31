import 'dart:io';

import 'package:image_music/common/constants.dart';
import 'package:image_music/providers/merge_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_music/common/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:video_trimmer/video_trimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _showAlertDialog(BuildContext context, MergeProvider prov) {
    // set up the button
    // Widget playPauseButton = FloatingActionButton(
    //   onPressed: () {
        // prov.controller.value.isPlaying
        //     ? prov.controller.pause()
        //     : prov.controller.play();
    //   },
    //   child: Icon(
    //     prov.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
    //   ),
    // );
    // set up the AlertDialog
    // AlertDialog alert = AlertDialog(
    //   title: Text("Output Video"),
    //   content: Center(
    //     child: prov.controller.value.isInitialized
    //         ? AspectRatio(
    //             aspectRatio: prov.controller.value.aspectRatio,
    //             child: VideoPlayer(prov.controller),
    //           )
    //         : Container(),
    //   ),
    //   actions: [playPauseButton],
    // );

    // show the dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
        // .whenComplete(() => prov.controller.dispose());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Provider.of<MergeProvider>(context, listen: false).trimmer
          .loadVideo(videoFile: File(Constants.OUTPUT_PATH));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Learning'),
          centerTitle: true,
          backgroundColor: Palette.primary,
        ),
        body: Consumer<MergeProvider>(
          builder: (context, prov, _) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VideoViewer(trimmer: prov.trimmer),
                  SizedBox(height: 5),
                  TrimEditor(
                    trimmer: prov.trimmer,
                    viewerHeight: 80.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: Duration(seconds: 15),
                    onChangeStart: (value) {
                      prov.setStartEndTime(0, value);
                    },
                    onChangeEnd: (value) {
                      prov.setStartEndTime(1, value);
                    },
                    onChangePlaybackState: (value) {
                      prov.setPlayPause(value);
                    },
                  ),
                  SizedBox(height: 15),
                  prov.loading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Palette.primary),
                            SizedBox(width: 15),
                            Text('Processing...',
                                style: TextStyle(color: Colors.black))
                          ],
                        )
                      : Container(),
                  SizedBox(height: 15),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        await prov.videoMerger();
                        // if (!prov.loading) _showAlertDialog(context, prov);
                        await prov.videoOutput();
                      },
                      child: Text('Merge',
                          style: TextStyle(color: Palette.tertiary)),
                      color: Palette.primary,
                      splashColor: Palette.secondary,
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: SfSlider(
                      min: 5,
                      max: 15,
                      stepSize: 5,
                      activeColor: Palette.primary,
                      inactiveColor: Palette.secondary,
                      value: prov.limit,
                      interval: 5,
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      onChanged: (dynamic value) {
                        prov.setTimeLimit(value);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
