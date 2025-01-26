import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ImagePicker _picker = ImagePicker();

  XFile? _video;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Welcome to Pressor'),
          ElevatedButton(
            onPressed: () async {
              final XFile? video =
                  await _picker.pickVideo(source: ImageSource.gallery);
              setState(() {
                _video = video;
              });
            },
            child: const Text('Pick a video'),
          ),
          if (_video != null) Text('Video: ${_video!.path}'),
        ],
      ),
    );
  }
}
