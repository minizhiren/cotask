// dialog_helpers.dart
import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(BuildContext context,
    {String title = 'Confirm Action',
    String content = 'Are you sure you want to proceed?'}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          actionsPadding: EdgeInsets.only(bottom: 12, right: 8),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 1,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
