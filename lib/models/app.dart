import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'image_item.dart';

enum ThemeId { system, light, dark }

class AppModel extends ChangeNotifier {
  AppModel() {
    initSettings();
  }

  final _token = 'cXkY9dRBtzDYWDMMuxgfyj4jaenOjjewV2TvlYHW2eg';
  final _apiUrl = 'https://api.unsplash.com/photos';
  int _page = 1;
  List<ImageItemModel> items = [];
  Future<http.Response>? itemsLoadingFuture;
  ThemeId _currentTheme = ThemeId.system;

  ThemeId get currentTheme => _currentTheme;

  set currentTheme(ThemeId currentTheme) {
    if (_currentTheme == currentTheme) return;
    _currentTheme = currentTheme;
    notifyListeners();
  }

  void saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentTheme', currentTheme.index);
  }

  void initSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('currentTheme') ?? _currentTheme.index;
    currentTheme = ThemeId.values[index];
  }

  void requestImages() async {
    _page = 1;
    final url = '$_apiUrl/?client_id=$_token&page=$_page';
    itemsLoadingFuture = http.get(Uri.parse(url));
    notifyListeners();
    http.Response? response;
    try {
      response = await itemsLoadingFuture;
    } catch (e) {
      return;
    }
    if (response?.statusCode != 200) return;
    final array = json.decode(response?.body ?? '{}') as List<dynamic>;
    items = array.map((item) => ImageItemModel.fromJson(item)).toList();
    notifyListeners();
  }

  void loadMoreImages() async {
    _page++;
    final url = '$_apiUrl/?client_id=$_token&page=$_page';
    http.Response response;
    try {
      response = await http.get(Uri.parse(url));
    } catch (e) {
      return;
    }
    if (response.statusCode != 200) return;
    final array = json.decode(response.body) as List<dynamic>;
    items.addAll(array.map((item) => ImageItemModel.fromJson(item)).toList());
    notifyListeners();
  }
}
