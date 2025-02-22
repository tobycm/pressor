import 'package:flutter/material.dart';
import 'package:pressor/compress.dart';
import 'package:pressor/models/compress_settings.dart';

class DefaultSettingsPage extends StatefulWidget {
  final DefaultSettings settings = DefaultSettings();

  DefaultSettingsPage({super.key});

  @override
  State<DefaultSettingsPage> createState() => _DefaultSettingsPageState();
}

class _DefaultSettingsPageState extends State<DefaultSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
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
                    Text("Default Resolution"),
                    DropdownButton(
                      borderRadius: BorderRadius.circular(16),
                      autofocus: true,
                      value: widget.settings.resolution,
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
                          widget.settings.resolution = resolution;
                        })
                      },
                    ),
                  ],
                ),
                Padding(padding: const EdgeInsets.all(10)),
                Text("Default FPS: ${widget.settings.fps ?? "Original"}"),
                Slider(
                  value: widget.settings.fps?.toDouble() ?? 0,
                  min: 0,
                  max: 120,
                  onChanged: (value) {
                    setState(() {
                      widget.settings.fps =
                          value.toInt() == 0 ? null : value.toInt();
                    });
                  },
                ),
                Padding(padding: const EdgeInsets.all(10)),
                Text(
                    "Default Bitrate: ${widget.settings.bitrate ?? "Original"}"),
                Slider(
                  value: widget.settings.bitrate?.toDouble() ?? 1000,
                  min: 1000,
                  max: 50000,
                  onChanged: (value) {
                    setState(() {
                      widget.settings.bitrate =
                          value == 1000 ? null : value.toInt();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
