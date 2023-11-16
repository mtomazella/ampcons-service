import 'package:flutter/material.dart';

class SummaryItem extends StatelessWidget {
  final Color color;
  final String label;
  final String? value;
  final String unit;
  final IconData icon;

  const SummaryItem(
      {super.key,
      required this.color,
      required this.label,
      required this.value,
      required this.unit,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.white);

    return Padding(
        padding: const EdgeInsets.all(10).copyWith(top: 5),
        child: Container(
            decoration: BoxDecoration(
                color: color.withOpacity(0.7),
                borderRadius: const BorderRadius.all(Radius.circular(6))),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: textStyle.copyWith(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            value == null
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    value ?? "??",
                                    style: textStyle.copyWith(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500),
                                  ),
                            Container(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                unit,
                                style: textStyle.copyWith(fontSize: 18),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
