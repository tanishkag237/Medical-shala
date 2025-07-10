import 'package:flutter/material.dart';

class MiniOverviewCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String count;
  final Color backgroundColor;

  const MiniOverviewCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.count,
    this.backgroundColor = const Color(0xFF63BBFF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170, // Fixed width that actually fits the content
      height: 75,
      child: Card(
        color: const Color(0xFFEEF8FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 6),
              // ✅ Wrap text area in a Flexible to avoid overflow
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      // maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF0078D4),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      count,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
