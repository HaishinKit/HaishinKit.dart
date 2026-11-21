import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'playback_page.dart';
import 'preference_page.dart';
import 'publish_page.dart';
import 'studio_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const HaishinKitExampleApp());
}

class HaishinKitExampleApp extends StatelessWidget {
  const HaishinKitExampleApp({super.key, this.initialDestination = 0});

  final int initialDestination;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'HaishinKit Flutter',
        debugShowCheckedModeBanner: false,
        theme: studioTheme(),
        supportedLocales: const [Locale('en'), Locale('ja')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: HaishinKitExample(initialDestination: initialDestination),
      );
}

class HaishinKitExample extends StatefulWidget {
  const HaishinKitExample({super.key, this.initialDestination = 0});

  final int initialDestination;

  @override
  State<HaishinKitExample> createState() => _HaishinKitExampleState();
}

class _HaishinKitExampleState extends State<HaishinKitExample> {
  late int _selectedIndex = widget.initialDestination;

  void _select(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.studioText('Publish', '配信'),
      context.studioText('Playback', '再生'),
      context.studioText('Settings', '設定')
    ];
    const icons = [
      Icons.videocam_outlined,
      Icons.play_arrow_rounded,
      Icons.settings_outlined
    ];
    final page = switch (_selectedIndex) {
      0 => PublishPage(onOpenSettings: () => _select(2)),
      1 => PlaybackPage(onOpenSettings: () => _select(2)),
      _ => const PreferencePage(),
    };
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selectedIndex != 0) _select(0);
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final rail = constraints.maxWidth >= 600;
        return Scaffold(
          body: Row(children: [
            if (rail)
              SafeArea(
                  child: NavigationRail(
                scrollable: true,
                selectedIndex: _selectedIndex,
                onDestinationSelected: _select,
                labelType: NavigationRailLabelType.all,
                destinations: List.generate(
                    3,
                    (index) => NavigationRailDestination(
                          icon: Icon(icons[index],
                              key: ValueKey('destination-$index')),
                          label: Text(labels[index]),
                        )),
              )),
            Expanded(
                child:
                    KeyedSubtree(key: ValueKey(_selectedIndex), child: page)),
          ]),
          bottomNavigationBar: rail
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _select,
                  destinations: List.generate(
                      3,
                      (index) => NavigationDestination(
                            icon: Icon(icons[index],
                                key: ValueKey('destination-$index')),
                            label: labels[index],
                          )),
                ),
        );
      }),
    );
  }
}
