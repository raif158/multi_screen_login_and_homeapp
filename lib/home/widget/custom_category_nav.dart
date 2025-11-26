import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryNav extends StatelessWidget {
  final List<String> category;
  final int selectedIndex;
  final Function(int) onTapIndex;
  const CategoryNav({
    super.key,
    required this.category,
    required this.selectedIndex,
    required this.onTapIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,

      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: category.length,
        itemBuilder: (context, index) {
          final bool isActive = index == selectedIndex;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onTapIndex(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isActive ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: isActive ? Colors.black : Colors.grey[400]!,
                    width: 2.0,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    category[index].toUpperCase(),
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
