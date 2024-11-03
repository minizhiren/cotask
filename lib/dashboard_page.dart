import 'package:flutter/material.dart';
import 'package:cotask/custom_widgets/bar_painter.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  State<DashBoardPage> createState() => _DashBoard();
}

class _DashBoard extends State<DashBoardPage> {
  int currentIndexPage = 0;
  final List<Tuple> valuesWithAvatars = [
    Tuple(150.0, './assets/profile_icon.png'),
    Tuple(300.0, './assets/profile_icon.png'),
    Tuple(100.0, './assets/profile_icon.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  // Removed the Expanded and wrapped the Container in a SizedBox to give it a finite height
                  SizedBox(
                    height: 100,
                    // Adjust this height to fit your design
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('./assets/pink_curtain.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 10, // move picture up
                      child: Text(
                        'Cotask',
                        style: TextStyle(
                          color: Color.fromARGB(255, 230, 100, 115),
                          fontSize: 30,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      )),
                ],
              ),

              const Visibility(
                // welcome
                visible: true,
                child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 40),
                    child: Text(
                      'Welcome, Five Guys',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    )),
              ),
              const SizedBox(
                height: 50,
              ),

              //CustomPainter
              // Adding the CustomPaint below the header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Great work',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Doing Good',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 14,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Time to Gear up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 280,
                    height: 300,
                    child: BarChartWithAvatars(),
                  ),
                ],
              ),

              //new alert
              Container(
                height: 200,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 50),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              Visibility(
                //our rewards
                visible: false,
                child: Container(
                  height: 150,
                  color: const Color(0xFFFDF2F6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        // Sign in
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const SignUpPage()),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: const Color(0xFFFA7D8A),
                          ),
                          child: const Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w900,
                              height: 0.10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
