import 'package:band_names/pages/home.dart';
import 'package:band_names/pages/status.dart';

class AppRoutes{
  static String initialRoute = 'home';
  static final routes = {
    'home': (_) => const HomePage(),
    'status': (_) => const StatusPage()
  };
}