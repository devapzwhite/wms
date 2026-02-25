import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';
import 'package:wms/features/auth/presentation/screens/screens_auth.dart';
import 'package:wms/features/home/presentation/screens/home_screen.dart';
import 'package:wms/features/vehicles/presentation/screens/vehicle_screens.dart';
import 'package:wms/features/workorders/presentation/screens/workorders_screens.dart';
import 'package:wms/presentation/screens/shared_screens.dart';
import '../../features/customers/presentation/screens/customer_screens.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final publicRoutes = ['/login', '/loadingScreen'];
  return GoRouter(
    initialLocation: '/loadingScreen',
    redirect: (context, state) {
      final currentlocation = state.matchedLocation;
      if (authState.status == AuthStatus.checking) {
        return currentlocation == '/loadingScreen' ? null : '/loadingScreen';
      }
      if (authState.status == AuthStatus.authenticated) {
        final tokenExpired = ref.read(authProvider.notifier).isTokenExpired();
        if (tokenExpired) {
          return '/login';
        }

        if (publicRoutes.contains(currentlocation)) {
          return '/home';
        }
      } else if (authState.status == AuthStatus.notAuthenticated) {
        if (currentlocation != '/login') {
          return '/login';
        }
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, _) => '/loadingScreen'),
      GoRoute(
        path: '/loadingScreen',
        builder: (context, state) => LoadingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
      GoRoute(
        path: '/customers',
        builder: (context, state) => CustomerMenuScreen(),
        routes: [
          GoRoute(
            path: 'addcustomer',
            builder: (context, state) => AddCustomerScreen(),
          ),
          GoRoute(
            path: 'updatecustomer/:id_customer',
            builder: (context, state) {
              final String idCustomer = state.pathParameters['id_customer']!;
              return UpdateCustomerScreen(idCustomer: int.parse(idCustomer));
            },
          ),
          GoRoute(
            path: 'details/:id_customer',
            builder: (context, state) {
              final idCustomer = state.pathParameters['id_customer']!;
              return CustomerDetailScreen(idCustomer: int.parse(idCustomer));
            },
          ),
        ],
      ),
      GoRoute(
        path: '/vehicles',
        builder: (context, state) => VehicleMenuScreen(),
        routes: [
          GoRoute(
            path: 'addvehicle',
            builder: (context, state) => AddVehicleScreen(),
          ),
          GoRoute(
            path: 'updatevehicle',
            builder: (context, state) => UpdateVehicleScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/workorders',
        builder: (context, state) => MenuWorkordersScreen(),
        routes: [
          GoRoute(
            path: 'addworkorder',
            builder: (context, state) => CreateWorkorderScreen(),
          ),
        ],
      ),
    ],
  );
});
