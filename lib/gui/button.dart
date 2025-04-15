import 'package:flutter/material.dart';

/// Button widget with up and down callbacks.
class Button extends StatefulWidget {
  /// Callback method executed when the button is pressed.
  Function onPressed;

  /// Callback method executed on the button is released.
  Function onReleased;

  /// Color of the button
  Color color;

  /// Color of the label
  Color labelColor;

  /// Label
  String label;

  Button(
      {required this.label,
      required this.color,
      required this.onPressed,
      required this.onReleased,
      this.labelColor = Colors.white,
      Key? key})
      : super(key: key);

  ButtonState createState() {
    return ButtonState();
  }
}

class ButtonState extends State<Button> {
  /// Indicates if the user is tapping the button.
  bool pressed = false;

  ButtonState();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 0.0),
        child: InkWell(
            enableFeedback: true,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onHighlightChanged: (bool highlight) {
              if (!this.pressed && highlight) {
                this.widget.onPressed();
              }

              if (this.pressed && !highlight) {
                this.widget.onReleased();
              }

              this.pressed = highlight;
              this.setState(() {});
            },
            onTap: () {},
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      color: this.pressed ? Colors.grey : this.widget.color,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Center(
                      child: Text(
                    this.widget.label,
                    style: TextStyle(color: this.widget.labelColor),
                  )))
            ])));
  }
}
