import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/domain/entities/entities.dart';
import 'package:wms/features/auth/presentation/providers/auth_provider.dart';

class AppBarCustom extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarCustom({required this.title});

  final String title;
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserSessionEntity userSession = ref.watch(authProvider).userSession!;
    return AppBar(
      centerTitle: true,
      elevation: 20,
      title: Text(
        title,
        //Workshop Management System
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          offset: Offset(0, 30),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      CircleAvatar(
                        radius: 30,
                        child: Text(
                          userSession.user.name.substring(0, 1).toUpperCase(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(userSession.user.name),
                      Text(userSession.user.email),
                      Divider(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                onTap: () {
                  //TODO: mostrar perfil del usuario
                },
              ),
              PopupMenuItem(
                child: Text("cerrar sesion"),
                onTap: () {
                  ref.read(authProvider.notifier).logout();
                  context.go('/login');
                },
              ),
            ];
          },
        ),
      ],
    );
  }
}
