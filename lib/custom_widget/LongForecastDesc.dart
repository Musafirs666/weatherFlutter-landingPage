import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LongForecastDesc extends StatefulWidget {
  final Widget image;
  final String textHour;
  final String textDesc;

  final bool isActive;

  const LongForecastDesc({
    Key? key,
    required this.isActive,
    required this.image,
    required this.textHour,
    required this.textDesc,
  }) : super(key: key);

  @override
  State<LongForecastDesc> createState() => _LongForecastDesc();
}

class _LongForecastDesc extends State<LongForecastDesc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 140,
      margin: const EdgeInsets.fromLTRB(0, 20, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        gradient: widget.isActive
            ? const LinearGradient(
                colors: [
                  Color(0xFFB0A4FF), // Warna gradient dari atas
                  Color(0xFF806EF8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(2.5, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.textHour,
              style:  TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      color: widget.isActive? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w600,
                      height: 1),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: 60,
              height: 60,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: widget.image,
            ),
            Text(
              widget.textDesc,
              style: TextStyle(
                fontSize: 20,
                color: widget.isActive ? Colors.white : Colors.grey,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
