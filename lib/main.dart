import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'merge_multimedia/home_screen.dart';
import 'merge_multimedia/providers/merge_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ImageAudioApp());
}

class ImageAudioApp extends StatefulWidget {
  @override
  _ImageAudioAppState createState() => _ImageAudioAppState();
}

class _ImageAudioAppState extends State<ImageAudioApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MergeProvider()),
      ],
      child: MaterialApp(home: HomeScreen()),
    );
  }
}
