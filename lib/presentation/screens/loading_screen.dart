import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';
import 'package:wms/infrastructure/datasource/services/key_value_storage_services.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  String hintText = 'Cargando...';
  bool isVerifying = true;
  final _storage = KeyValueStorageServicesImpl();

  final List<String> hintTextInit = [
    'Preparando todo para ti...',
    'Cargando datos del servidor...',
    'Casi listo, solo un momento...',
    'Optimizando tu experiencia...',
    'Conectando con la base de datos...',
    'Verificando tu conexión...',
    'Sincronizando información...',
  ];
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(hintText),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeApp() async {
    await Future.wait([_showRandomHint(), _verifyToken()]);
  }

  Future<void> _showRandomHint() async {
    int index = 0;
    while (isVerifying && index < hintTextInit.length) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      setState(() {
        hintText = hintTextInit[index];
      });
      index++;
    }
  }

  Future<void> _verifyToken() async {
    bool hasValidToken = false;
    try {
      // await Future.delayed(Duration(milliseconds: 800));
      final userSession = await _storage.getUserSession();
      //para controlar el tiempo de expiracion del token, se puede usar el siguiente codigo
      print(
        'token: ${userSession?.token.accessToken} expiresAt: ${userSession?.token.expiresAt}',
      );
      if (userSession != null) {
        hasValidToken = DateTime.now().isBefore(userSession.token.expiresAt);
        if (hasValidToken) {
          ref.read(authProvider.notifier).setUserSession(userSession);
        }
      }
    } catch (e) {
      hasValidToken = false;
    }
    isVerifying = false;
    if (!mounted) return;
    //redirige a la pantalla principal
    if (!hasValidToken) {
      ref.read(authProvider.notifier).logout();
    }
  }
}
