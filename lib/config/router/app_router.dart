import 'package:go_router/go_router.dart';
import 'package:wms/features/auth/presentation/screens/screens_auth.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [GoRoute(path: '/login', builder: (context, state) => LoginScreen())],
);
