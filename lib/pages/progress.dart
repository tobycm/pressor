import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:pressor/compress.dart';

enum CompressionState {
  pending,
  compressing,
  completed,
  errored,
}

class CompressionProgress extends StatefulWidget {
  final CompressContext compressContext;

  const CompressionProgress({super.key, required this.compressContext});

  @override
  State<CompressionProgress> createState() => _CompressionProgressState();
}

class _CompressionProgressState extends State<CompressionProgress> {
  // ignore: prefer_final_fields
  int _progress = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReturnCode?>(
      future: (() async {
        // setState(() {
        //   _state = CompressionState.compressing;
        // });

        // var ffprobeSession = await FFprobeKit.execute(
        //   '-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${widget.compressContext.video.path}"',
        // );

        // var durationStr = await ffprobeSession.getOutput();
        // if (durationStr == null) {
        //   return;
        // }

        // var duration = double.parse(durationStr);

        // var session = await startCompressSession(
        //   widget.compressContext,
        //   (session) {
        //     setState(() {
        //       _progress = 100;
        //       _state = CompressionState.completed;
        //     });
        //   },
        //   (l) {
        //     log("ffmpeg log: ${l.getMessage()}");
        //   },
        //   (stat) {
        //     setState(() {
        //       _progress = (stat.getTime() / duration * 100).ceil();
        //       if (_progress > 100) {
        //         _progress = 100;
        //       }
        //     });
        //   },
        // );

        // // print(File(widget.compressContext.video.path)
        // //     .existsSync()); // Should print true

        // // print(session.getCommand());

        // FFmpegKitConfig.ffmpegExecute(session);

        // var code = await session.getReturnCode();
        // if (code == null) {
        //   return;
        // }

        // if (ReturnCode.isSuccess(code)) {
        //   setState(() {
        //     _state = CompressionState.completed;
        //   });

        //   await Gal.putVideo(widget.compressContext.outputPath());

        //   return;
        // }

        // log('Compression failed with code $code');

        // setState(() {
        //   _state = CompressionState.errored;
        // });

        // return;

        var session = await startCompressSession(widget.compressContext);

        await FFmpegKitConfig.asyncFFmpegExecute(session);

        var code = await session.getReturnCode();

        await Gal.putVideo(widget.compressContext.outputPath());

        return code;
      })(),
      builder: (context, snapshot) => Scaffold(
        appBar: snapshot.connectionState == ConnectionState.done
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              )
            : null,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (snapshot.connectionState == ConnectionState.none) ...[
              CircularProgressIndicator(),
              Text(
                'Starting compression...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
            if (snapshot.connectionState == ConnectionState.waiting) ...[
              CircularProgressIndicator(value: _progress / 100),
              Text(
                'Progress: $_progress%',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
            if (snapshot.connectionState == ConnectionState.done) ...[
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 48,
              ),
              Text(
                'Compression completed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
            if (snapshot.hasError) ...[
              Icon(
                Icons.error,
                color: Colors.white,
                size: 48,
              ),
              Text(
                'Compression failed: ${snapshot.error}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
          ]),
        ),
      ),
    );
  }
}
