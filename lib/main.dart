import 'package:flutter/material.dart';
import 'package:gallery_example/load_more_item.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'models/app.dart';
import 'card_item.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  ThemeMode getThemeMode(ThemeId theme) {
    switch (theme) {
      case ThemeId.system:
        return ThemeMode.system;
      case ThemeId.light:
        return ThemeMode.light;
      default:
        return ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return AppModel()..requestImages();
        }),
      ],
      child: Selector<AppModel, ThemeId>(
        selector: (context, app) => app.currentTheme,
        builder: (context, currentTheme, _) {
          final theme = getThemeMode(currentTheme);
          return MaterialApp(
            title: 'Gallery',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            themeMode: theme,
            home: const App(title: 'Gallery Home Page'),
          );
        },
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key, required this.title}) : super(key: key);

  final String title;

  Widget buildLayout({required Widget child}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Consumer<AppModel>(
            builder: (context, app, _) {
              return IconButton(
                icon: app.currentTheme == ThemeId.dark
                    ? const Icon(Icons.brightness_5, color: Colors.white)
                    : const Icon(Icons.brightness_4, color: Colors.white),
                onPressed: () {
                  final isDark = app.currentTheme == ThemeId.dark;
                  app.currentTheme = isDark ? ThemeId.light : ThemeId.dark;
                  app.saveTheme();
                },
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildLayout(
      child: Consumer<AppModel>(builder: (context, app, _) {
        final orientation = MediaQuery.of(context).orientation;
        return FutureBuilder<http.Response>(
            future: app.itemsLoadingFuture,
            builder: (_, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const Center(child: CircularProgressIndicator());

                case ConnectionState.done:
                  if (snapshot.data == null ||
                      snapshot.data?.statusCode != 200) {
                    return buildErrorMessage(app);
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        Future.microtask(() => app.requestImages()),
                    child: GridView.count(
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 3,
                      children: app.items.map<StatelessWidget>((item) {
                        return CardItem(item: item);
                      }).toList()
                        ..add(const LoadMoreItem()),
                    ),
                  );
                default:
                  return const SizedBox.expand();
              }
            });
      }),
    );
  }

  Widget buildErrorMessage(AppModel app) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Loading error.',
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            child: const Text('Reload page'),
            onPressed: () => app.requestImages(),
          )
        ],
      ),
    );
  }
}
