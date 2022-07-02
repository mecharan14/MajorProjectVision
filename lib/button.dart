import 'package:flutter/material.dart';

class UIButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onPressed;

  const UIButton({Key key, this.onPressed, this.text, this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(.2),
              ),
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            if (icon != null) Icon(icon),
            if (icon != null) SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
