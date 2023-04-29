class HomeMenu {
  final String _name;
  final String _icon;
  final String _color;

  HomeMenu(this._name, this._icon, this._color);

  String getName() => _name;
  String getIcon() => _icon;
  String getColor() => _color;

  Map<String, dynamic> toJson() =>
      {'name': _name.trim(), 'icon': _icon.trim(), 'color': _color.trim()};

  HomeMenu.fromJson(Map<String, dynamic> json)
      : _name = json['username'],
        _icon = json['email'],
        _color = json['color'];
}
