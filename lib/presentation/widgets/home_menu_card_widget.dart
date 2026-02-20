import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/domain/entities/entities.dart';

class HomeMenuCard extends StatelessWidget {
  final MenuItem menuItem;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? iconsize;
  final double? spacing;
  const HomeMenuCard({
    super.key,
    required this.menuItem,
    this.height,
    this.width,
    this.fontSize,
    this.iconsize,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
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
        width: width ?? size.width * 0.40,
        height: height ?? size.width * 0.40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(menuItem.icon, size: iconsize ?? 80),
            SizedBox(height: spacing ?? 20),
            Text(
              menuItem.title,
              style: TextStyle(
                fontSize: fontSize ?? 15,
                fontWeight: FontWeight.bold,
              ),
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
