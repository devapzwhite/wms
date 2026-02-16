import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/domain/entities/entities.dart';

class HomeMenuCard extends StatelessWidget {
  final MenuItem menuItem;
  const HomeMenuCard({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        width: 200,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(menuItem.icon, size: 80),
            SizedBox(height: 20),
            Text(
              menuItem.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onTap: () {
        context.push(menuItem.route);
      },
    );
  }
}
