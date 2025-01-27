import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:image_picker/image_picker.dart';

class CompressContext {
  final XFile video;

  final CompressSettings settings = CompressSettings();

  String? destinationFolder;

  CompressContext({required this.video});
}

class Resolution {
  final String name;
  final int width;
  final int height;

  const Resolution(this.name, this.width, this.height);

  @override
  String toString() => name;
}

const Map<String, Resolution> resolutions = {
  '1080p': Resolution('1080p', 1920, 1080),
  '720p': Resolution('720p', 1280, 720),
  '480p': Resolution('480p', 854, 480),
  '360p': Resolution('360p', 640, 360),
  '240p': Resolution('240p', 426, 240),
};

class CompressSettings {
  Resolution? resolution;
  int? bitrate;
  int? fps;

  CompressSettings({
    this.resolution,
    this.bitrate,
    this.fps,
  });
}

Future<FFmpegSession> startCompressSession(CompressContext context) async {
  var output = "${context.destinationFolder}/${context.video.name}.mp4";

  return await FFmpegSession.create([
    "-i",
    context.video.path,
    if (context.settings.resolution != null) ...[
      "-vf",
      "scale=${context.settings.resolution!.width}:${context.settings.resolution!.height}",
    ],
    if (context.settings.bitrate != null) ...[
      "-b:v",
      "${context.settings.bitrate}k",
    ],
    if (context.settings.fps != null) ...[
      "-r",
      "${context.settings.fps}",
    ],
    output,
  ]);
}
