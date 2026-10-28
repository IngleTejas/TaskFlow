class ApiConfig {
  // ── Choose the correct URL for your run target ────────────────────────────
  //
  // Flutter web (Chrome) + Laravel on same machine:
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  //
  // Android emulator + Laravel on same machine:
  //   static const String baseUrl = 'http://10.0.2.2:8000/api';
  //
  // Physical Android device (USB debug) + Laravel on same machine:
  //   Replace 192.168.x.x with your PC's LAN IP shown by `ipconfig`
  //   static const String baseUrl = 'http://192.168.x.x:8000/api';
  //
  // Windows desktop + Laravel on same machine:
  //   static const String baseUrl = 'http://127.0.0.1:8000/api';
  // ──────────────────────────────────────────────────────────────────────────

  static const Duration timeout = Duration(seconds: 15);
}

