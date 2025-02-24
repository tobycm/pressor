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
  int _progress = 0;
  ReturnCode? _returnCode;

  @override
  void initState() {
    super.initState();
    _startCompression();
  }

  Future<ReturnCode?> _startCompression() async {
    var session = await startCompressSession(
      widget.compressContext,
      (session) {
        // completed
      },
      (log) {},
      (statistics) {
        setState(() {
          _progress = (statistics.getTime() / 1000).toInt();
        });
      },
    );

    await FFmpegKitConfig.asyncFFmpegExecute(session);

    var code = await session.getReturnCode();

    if (ReturnCode.isSuccess(code)) {
      await Gal.putVideo(widget.compressContext.outputPath());
    }

    setState(() {
      _returnCode = code;
    });

    return code;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _progress == 100
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
            if (_progress == 0) ...[
              CircularProgressIndicator(),
              Text(
                'Starting compression...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
            if (_progress != 0 && _progress != 100) ...[
              CircularProgressIndicator(value: _progress / 100),
              Text(
                'Progress: $_progress%',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
            if (_progress == 100) ...[
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
            if (!ReturnCode.isSuccess(_returnCode)) ...[
              Icon(
                Icons.error,
                color: Colors.white,
                size: 48,
              ),
              Text(
                'Compression failed: Error: ${_returnCode?.toString()}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
          ]),
        ),
      );
}
