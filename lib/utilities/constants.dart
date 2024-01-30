import 'package:flutter/material.dart';

class BookmarksNavBarButton extends StatelessWidget {
  final IconData icon;

  const BookmarksNavBarButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffffd803),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: const Color(0xff272343),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0xffbae8e8),
              offset: Offset(4.0, 4.0),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 24.0,
          color: const Color(0xff272343),
        ),
      ),
    );
  }
}

class SearchNavBarButton extends StatelessWidget {
  final IconData icon;

  const SearchNavBarButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Icon(
        icon,
        size: 24.0,
        color: const Color(0xff272343),
      ),
    );
  }
}
