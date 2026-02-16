import 'package:go_router/go_router.dart';
import 'package:wms/features/auth/presentation/screens/screens_auth.dart';
import 'package:wms/features/home/presentation/screens/home_screen.dart';
import 'package:wms/presentation/screens/shared_screens.dart';

final appRouter = GoRouter(
  initialLocation: '/loadingScreen',
  routes: [
    GoRoute(
      path: '/loadingScreen',
      builder: (context, state) => LoadingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
  ],
);
