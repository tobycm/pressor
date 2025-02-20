import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:pressor/components/buttons/blue.dart';
import 'package:pressor/compress.dart';
import 'package:pressor/pages/summary.dart';

class SaveTo extends StatefulWidget {
  final CompressContext compressContext;

  const SaveTo({super.key, required this.compressContext});

  @override
  State<SaveTo> createState() => _SaveToState();
}

class _SaveToState extends State<SaveTo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Save to',
            style: TextStyle(fontWeight: FontWeight.w500)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add a button to pick destination folder
            ElevatedButton(
              style: BlueButton(context),
              onPressed: () async {
                String? path = await FilesystemPicker.open(
                  title: 'Folder to save compressed video',
                  context: context,
                  rootDirectory: Directory("/"),
                  directory: Directory(Platform.isLinux || Platform.isMacOS
                      ? Platform.environment['HOME'] ?? "/home/"
                      : "/"),
                  fsType: FilesystemType.folder,
                  pickText: 'Save results to this folder',
                );

                setState(() {
                  widget.compressContext.destinationFolder = path;
                });
              },
              child: const Text(
                'Pick destination folder',
                style: TextStyle(fontSize: 24),
              ),
            ),

            if (widget.compressContext.destinationFolder != null) ...[
              Padding(padding: const EdgeInsets.all(10)),
              Text(
                'Destination folder: ${widget.compressContext.destinationFolder!.split("/").last}',
                style: TextStyle(fontSize: 24),
              ),
              Padding(padding: const EdgeInsets.all(10)),
              ElevatedButton(
                style: BlueButton(context),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Review(compressContext: widget.compressContext),
                  ),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 24)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
