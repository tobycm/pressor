import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pressor/components/buttons/blue.dart';
import 'package:pressor/compress.dart';
import 'package:pressor/pages/save_to.dart';
import 'package:pressor/pages/summary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompressOptions extends StatefulWidget {
  final CompressContext compressContext;

  const CompressOptions({super.key, required this.compressContext});

  @override
  State<CompressOptions> createState() => _CompressOptionsState();
}

class _CompressOptionsState extends State<CompressOptions> {
  @override
  void initState() {
    super.initState();
    _loadDefaultSettings();
  }

  void _loadDefaultSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("default_resolution")) {
      widget.compressContext.settings.resolution =
          resolutions[prefs.getString("default_resolution")!];
    }

    if (prefs.containsKey("default_bitrate")) {
      widget.compressContext.settings.bitrate = prefs.getInt("default_bitrate");
    }

    if (prefs.containsKey("default_fps")) {
      widget.compressContext.settings.fps = prefs.getInt("default_fps");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Options',
            style: TextStyle(fontWeight: FontWeight.w500)),
      ),
      body: DefaultTextStyle(
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Resolution"),
                    DropdownButton(
                      borderRadius: BorderRadius.circular(16),
                      autofocus: true,
                      value: widget.compressContext.settings.resolution,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                      underline: Container(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text("Original"),
                        ),
                        ...resolutions.values.map(
                          (resolution) => DropdownMenuItem(
                            value: resolution,
                            child: Text("$resolution"),
                          ),
                        )
                      ],
                      onChanged: (resolution) => {
                        setState(() {
                          widget.compressContext.settings.resolution =
                              resolution;
                        })
                      },
                    ),
                  ],
                ),
                Padding(padding: const EdgeInsets.all(10)),
                Text(
                    "FPS: ${widget.compressContext.settings.fps ?? "Original"}"),
                Slider(
                  value: widget.compressContext.settings.fps?.toDouble() ?? 0,
                  min: 0,
                  max: 120,
                  onChanged: (value) {
                    setState(() {
                      widget.compressContext.settings.fps =
                          value.toInt() == 0 ? null : value.toInt();
                    });
                  },
                ),
                Padding(padding: const EdgeInsets.all(10)),
                Text(
                    "Bitrate: ${widget.compressContext.settings.bitrate ?? "Original"}"),
                Slider(
                  value: widget.compressContext.settings.bitrate?.toDouble() ??
                      1000,
                  min: 1000,
                  max: 50000,
                  onChanged: (value) {
                    setState(() {
                      widget.compressContext.settings.bitrate =
                          value == 1000 ? null : value.toInt();
                    });
                  },
                ),
                Padding(padding: const EdgeInsets.all(10)),
                ElevatedButton(
                  onPressed: () {
                    if (Platform.isIOS || Platform.isAndroid) {
                      widget.compressContext.destinationFolder =
                          Directory.systemTemp.path;
                    }

                    var to = Platform.isIOS || Platform.isAndroid
                        ? Review(compressContext: widget.compressContext)
                        : SaveTo(compressContext: widget.compressContext);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => to),
                    );
                  },
                  style: BlueButton(context),
                  child: const Text('Next', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
