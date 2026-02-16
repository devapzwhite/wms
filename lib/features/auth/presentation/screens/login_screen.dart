import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';
import 'package:wms/features/auth/presentation/providers/login_form_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    const radius = Radius.circular(10);
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    final cardHeight = isPortrait ? size.height * 0.5 : size.height * 0.75;

    final loginState = ref.watch(loginFormProvider);
    ref.listen(authProvider, (previous, next) {
      if (next.userSession != null) {
        context.go('/home');
      }
    });
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(next.errorMessage)));
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 0, 17, 255),
                      Color(0xFF8F4CFF),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1,
                  vertical: size.height * 0.1,
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Align(
                        child: const Text(
                          "WMS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: size.width * 0.8,
                  height: cardHeight + 20,
                  decoration: BoxDecoration(
                    color: colors.surfaceBright,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(10, 20),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      child: Column(
                        spacing: isPortrait ? 20 : 10,
                        children: [
                          SizedBox(height: isPortrait ? 10 : 5),
                          Text(
                            'Iniciar Sesion',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              onChanged: ref
                                  .read(loginFormProvider.notifier)
                                  .updateUsername,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Username",
                                errorText: loginState.username.errorMessage,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              onChanged: ref
                                  .read(loginFormProvider.notifier)
                                  .updatePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Password",
                                errorText: loginState.password.errorMessage,
                              ),
                            ),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.primary,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: radius,
                                  bottomRight: radius,
                                  topLeft: radius,
                                ),
                              ),
                            ),
                            onPressed: ref
                                .read(loginFormProvider.notifier)
                                .submit,
                            child: Text("Ingresar"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
