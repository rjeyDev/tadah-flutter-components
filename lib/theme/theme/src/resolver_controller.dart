// @dart=2.9
part of 'resolver.dart';

class ThemeResolverController {
  ThemeResolverController._({
    @required Map<AppThemeVariety, AppThemeData> themes,
    @required AppThemeMode mode,
  })  : assert(themes != null),
        assert(mode != null),
        _themes = themes,
        _mode = mode {
    _lightThemes = Map.fromEntries(
      themes.entries.where((entry) => entry.value.type == AppThemeType.Light),
    );

    assert(_lightThemes.isNotEmpty);

    _darkThemes = Map.fromEntries(
      themes.entries.where((entry) => entry.value.type == AppThemeType.Dark),
    );

    assert(_darkThemes.isNotEmpty);

    _current = _themes.keys.first;
    _currentLight = _lightThemes.keys.first;
    _currentDark = _darkThemes.keys.first;
  }

  final StreamController _themesStreamController =
      StreamController<AppThemeData>();

  Map<AppThemeVariety, AppThemeData> _themes;
  Map<AppThemeVariety, AppThemeData> _lightThemes;
  Map<AppThemeVariety, AppThemeData> _darkThemes;

  AppThemeVariety _current;
  AppThemeVariety _currentLight;
  AppThemeVariety _currentDark;

  AppThemeMode _mode;
  Brightness _platformBrightness;

  AppThemeData get currentTheme => _themes[_current];

  AppThemeVariety get currentThemeVariety => _current;

  Stream<AppThemeData> get _themesStream => _themesStreamController.stream;

  bool get isSystemMode => _mode == AppThemeMode.System;

  void _setPlatformBrightness(Brightness brightness) {
    _platformBrightness = brightness;

    if (isSystemMode) {
      _handleSystemTheme();
    }
  }

  void setMode(AppThemeMode mode) {
    if (_mode == mode) return;

    _mode = mode;
    if (isSystemMode) {
      _handleSystemTheme();
    }
  }

  void setTheme(AppThemeVariety theme) {
    if (isSystemMode && !_checkIsValidSystemModeTheme(theme)) return;

    AppThemeData currentTheme = _themes[theme];

    _current = theme;

    if (currentTheme.type == AppThemeType.Light) {
      _currentLight = theme;
    } else {
      _currentDark = theme;
    }

    _themesStreamController.sink.add(currentTheme);
  }

  void nextTheme() {
    Map<AppThemeVariety, AppThemeData> themes = _mode == AppThemeMode.Manual
        ? _themes
        : (_platformBrightness == Brightness.light
            ? _lightThemes
            : _darkThemes);

    List<AppThemeVariety> themesKeys = themes.keys.toList();

    setTheme(
      themesKeys[(themesKeys.indexOf(_current) + 1) % themesKeys.length],
    );
  }

  void _handleSystemTheme() {
    setTheme(
      _platformBrightness == Brightness.light ? _currentLight : _currentDark,
    );
  }

  bool _checkIsValidSystemModeTheme(AppThemeVariety theme) {
    switch (_platformBrightness) {
      case Brightness.light:
        if (_lightThemes[theme] == null) return false;
        break;
      case Brightness.dark:
        if (_darkThemes[theme] == null) return false;
        break;
    }
    return true;
  }

  void dispose() {
    _themesStreamController?.close();
  }
}
