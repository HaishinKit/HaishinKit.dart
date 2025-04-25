import 'package:flutter/material.dart';
import 'package:haishin_kit_example/preference.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  State<StatefulWidget> createState() => PreferenceState();
}

class PreferenceState extends State<PreferencePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("RTMP URL:"),
                        TextFormField(
                          initialValue: Preference.shared.url,
                          onChanged: (text) {
                            Preference.shared.url = text;
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("RTMP streamName:"),
                        TextFormField(
                          initialValue: Preference.shared.streamName,
                          onChanged: (text) {
                            Preference.shared.streamName = text;
                          },
                        ),
                      ],
                    )
                  ]))),
    );
  }
}
