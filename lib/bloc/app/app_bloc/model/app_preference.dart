import 'package:superpower/bloc/app/app_bloc/model/home_menu.dart';

class AppPreference {
  final List<HomeMenu> _homeMenu;

  AppPreference(this._homeMenu);

  List<HomeMenu> getHomeMenu() => _homeMenu;

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  List<Map<String, dynamic>> homeMenuJsonList =
      _homeMenu.map((menu) => menu.toJson()).toList();
  data['home_menu'] = homeMenuJsonList;
  return data;
}

  factory AppPreference.fromJson(Map<String, dynamic> json) {
    var homeMenuList = json['home_menu'] as List;
    List<HomeMenu> homeMenu =
        homeMenuList.map((json) => HomeMenu.fromJson(json)).toList();
    return AppPreference(homeMenu);
  }
}
