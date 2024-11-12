import 'package:flutter/material.dart';

class BarChartWithAvatars extends StatelessWidget {
  final List<Tuple> valuesWithAvatars = [
    Tuple(150.0, './assets/profile_icon.png'),
    Tuple(300.0, './assets/profile_icon.png'),
    Tuple(100.0, './assets/profile_icon.png'),
  ];

  BarChartWithAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the height of the screen
    double screenHeight = MediaQuery.of(context).size.height;

    // Set the maximum height for the bars
    double maxBarHeight = screenHeight *
        0.3; // The maximum bar height is set to 30% of the screen height

    // Find the maximum value
    double maxValue = valuesWithAvatars
        .map((tuple) => tuple.value)
        .reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor:
          Colors.white, // Match this with homepage's background color
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: valuesWithAvatars.map((tuple) {
            // Normalize the height of the bar
            double normalizedHeight = (tuple.value / maxValue) * maxBarHeight;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // The bar, using Align to fix the position at the bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 40,
                    height: normalizedHeight, // Use the normalized height
                    decoration: BoxDecoration(
                      color: Color.lerp(
                          Colors.blue, Colors.pink, tuple.value / maxValue),
                      border: Border.all(color: Colors.black), // Border
                      borderRadius:
                          BorderRadius.circular(120), // Make the border smooth
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // The avatar below the bar
                Image.asset(
                  tuple.avatarPath,
                  width: 40,
                  height: 40,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Tuple {
  final double value;
  final String avatarPath;

  Tuple(this.value, this.avatarPath);
}

void main() {
  runApp(MaterialApp(
    home: BarChartWithAvatars(),
  ));
}
