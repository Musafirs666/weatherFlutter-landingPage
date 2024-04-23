import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavbarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const NavbarIcon({
    Key? key,
    required this.icon,
    required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(2.5, 10),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 30,
        ),
      ),
    );
  }
}
