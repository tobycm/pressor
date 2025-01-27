import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pressor/components/buttons/blue.dart';
import 'package:pressor/compress.dart';
import 'package:pressor/pages/options.dart';

class PickVideo extends StatefulWidget {
  const PickVideo({super.key});

  @override
  State<PickVideo> createState() => _PickVideoState();
}

class _PickVideoState extends State<PickVideo> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: BlueButton(context),
      onPressed: () async {
        final XFile? video =
            await _picker.pickVideo(source: ImageSource.gallery);

        if (!context.mounted || video == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompressOptions(
              compressContext: CompressContext(video: video),
            ),
          ),
        );
      },
      child: Text('Pick a video', style: TextStyle(fontSize: 24)),
    );
  }
}
