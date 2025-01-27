import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:pressor/compress.dart';

class CompressionProgress extends StatefulWidget {
  final CompressContext compressContext;

  const CompressionProgress({super.key, required this.compressContext});

  @override
  State<CompressionProgress> createState() => _CompressionProgressState();
}

class _CompressionProgressState extends State<CompressionProgress> {
  int _progress = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: (() async {
        var ffprobeSession = await FFprobeKit.execute(
          '-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${widget.compressContext.video.path}"',
        );

        var durationStr = await ffprobeSession.getOutput();

        if (durationStr == null) {
          return;
        }

        var duration = double.parse(durationStr);

        print('Duration: $duration');

        var session = await startCompressSession(widget.compressContext);

        FFmpegKitConfig.ffmpegExecute(session);

        print('Started session: $session');

        while (_progress < 100) {
          await Future.delayed(const Duration(milliseconds: 100));

          var stats = await session.getStatistics();

          print('Stats: $stats');

          for (var stat in stats) {
            print(stat.getTime());

            setState(() {
              _progress = (stat.getTime() / duration * 100).ceil();
            });
          }
        }

        return;
      })(),
      builder: (context, snapshot) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(value: _progress / 100),
              Text(
                'Progress: $_progress%',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
