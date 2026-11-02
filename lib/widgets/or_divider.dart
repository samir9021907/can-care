import 'package:flutter/material.dart';

/// Clean divider with centered "or" text matching the reference specification
class OrDivider extends StatelessWidget {
  final double verticalPadding;

  const OrDivider({super.key, this.verticalPadding = 20});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: const Row(
        children: [
          Expanded(
            child: Divider(
              color: Color(0xFFDEE7DF),
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7E9284),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Color(0xFFDEE7DF),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
