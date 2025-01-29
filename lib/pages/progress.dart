import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session_state.dart';
import 'package:flutter/material.dart';
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
  int _progress = 0;

  CompressionState _state = CompressionState.pending;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: (() async {
        setState(() {
          _state = CompressionState.compressing;
        });

        var ffprobeSession = await FFprobeKit.execute(
          '-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${widget.compressContext.video.path}"',
        );

        var durationStr = await ffprobeSession.getOutput();
        if (durationStr == null) {
          return;
        }

        var duration = double.parse(durationStr);

        var session = await startCompressSession(widget.compressContext);

        print(session.getCommand());

        FFmpegKitConfig.ffmpegExecute(session);

        while (_progress < 100) {
          await Future.delayed(const Duration(milliseconds: 100));

          if (await session.getState() == SessionState.completed) {
            var code = await session.getReturnCode();

            if (ReturnCode.isSuccess(code)) {
              setState(() {
                _progress = 100;
                _state = CompressionState.completed;
              });
              break;
            } else {
              print('Compression failed with code $code');
              setState(() {
                _state = CompressionState.errored;
              });
              break;
            }
          }

          var stat = (await session.getStatistics()).first;
          print("$duration / ${stat.getTime()}");

          // setState(() {
          //   _progress = (stat.getTime() / duration * 100).ceil();
          // });
        }

        var code = await session.getReturnCode();
        if (code == null) {
          return;
        }

        if (ReturnCode.isSuccess(code)) {
          setState(() {
            _state = CompressionState.completed;
          });
        } else {
          print('Compression failed with code $code');
          // print(await session.getLogsAsString());
          setState(() {
            _state = CompressionState.errored;
          });
        }

        return;
      })(),
      builder: (context, snapshot) => Scaffold(
        appBar: _progress == 100
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
                title: const Text('Home',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              )
            : null,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (_state == CompressionState.pending) ...[
              CircularProgressIndicator(),
              Text(
                'Starting compression...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
            if (_state == CompressionState.compressing) ...[
              CircularProgressIndicator(value: _progress / 100),
              Text(
                'Progress: $_progress%',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
            if (_state == CompressionState.completed) ...[
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
            if (_state == CompressionState.errored) ...[
              Icon(
                Icons.error,
                color: Colors.white,
                size: 48,
              ),
              Text(
                'Compression failed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
          ]),
        ),
      ),
    );
  }
}
