import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    const radius = Radius.circular(10);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height * 0.50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 0, 17, 255), Color(0xFF8F4CFF)],
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
              height: size.height * 0.5,
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
                    spacing: 20,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Iniciar Sesion',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
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
                        onPressed: () {},
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
    );
  }
}
