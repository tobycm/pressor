import 'package:flutter/material.dart';
import 'package:pressor/components/buttons/blue.dart';
import 'package:pressor/compress.dart';
import 'package:pressor/pages/progress.dart';

class Review extends StatelessWidget {
  final CompressContext compressContext;

  const Review({super.key, required this.compressContext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Summary',
            style: TextStyle(fontWeight: FontWeight.w500)),
      ),
      body: DefaultTextStyle(
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        // textAlign: TextAlign.center,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Video file: ${compressContext.video.path.split("/").last}",
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Text(
                "Destination folder: ${compressContext.destinationFolder!.split("/").last}",
              ),
              Text(
                "Resolution: ${compressContext.settings.resolution ?? "Unchanged"}",
              ),
              Text(
                "Bitrate: ${compressContext.settings.bitrate ?? "Unchanged"}",
              ),
              Text(
                "FPS: ${compressContext.settings.fps ?? "Unchanged"}",
              ),
              const Padding(padding: EdgeInsets.all(16)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: BlueButton(context),
                  onPressed: () => {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompressionProgress(
                          compressContext: compressContext,
                        ),
                      ),
                      (route) => route.isFirst,
                    )
                  },
                  child: const Text("Start compression",
                      style: TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
