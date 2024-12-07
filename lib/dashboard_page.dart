import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cotask/providers/user_provider.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final List<Color> barColors = [
    Color(0xFFF66372),
    Color(0xFFF66372),
  ]; // Both bars set to the same color

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // Exclude a user by unique ID
    final users = userProvider.userList.where((user) => user.id != 0).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(106.0),
        child: Material(
          elevation: 4.0,
          child: AppBar(
            leadingWidth: 72,
            toolbarHeight: 106,
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: Container(
              alignment: Alignment.bottomLeft,
              margin: const EdgeInsets.only(left: 18, bottom: 18),
              child: SvgPicture.asset('assets/burgur.svg'),
            ),
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Color(0xFFF66372),
                    fontSize: 30,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Credits',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                // Use SizedBox to limit the height of BarChart
                SizedBox(
                  height: 300, // Set a fixed height for the chart
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: users
                              .map((user) => user.credit)
                              .reduce((a, b) => a > b ? a : b) *
                          1.2,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: SideTitles(
                          showTitles: false, // Hide Y-axis labels
                        ),
                        bottomTitles: SideTitles(
                          showTitles: false, // Hide X-axis labels
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        horizontalInterval: 50,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: users
                          .asMap()
                          .map((index, user) => MapEntry(
                                index,
                                BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      y: user.credit,
                                      colors: [
                                        barColors[index % barColors.length]
                                      ],
                                      width: 16,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                              ))
                          .values
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 22.0), // Add 2px padding here for Me
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/me_prof.png'),
                    ),
                    const SizedBox(
                        height: 10), // Spacing between name and image
                    const Text(
                      'Me',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 15.0), // Add 15px padding here for Lucas
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/lucas_prof.png'),
                    ),
                    const SizedBox(
                        height: 10), // Spacing between name and image
                    const Text(
                      'Lucas',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
