import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClassCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const ClassCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final videoCount = int.tryParse(
          RegExp(r'\d+').firstMatch(subtitle)?.group(0) ?? '',
        ) ??
        0;
    return GestureDetector(
      onTap: () {
        context.push('/class-detail', extra: {
          'title': title,
          'image': image,
          'videoCount': videoCount,
          'description': '',
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: const Color(0xFFA78BFA).withOpacity(0.9),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

