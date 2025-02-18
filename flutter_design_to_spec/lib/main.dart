import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      debugShowCheckedModeBanner: false,
      // TO-DO Update the font being used
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontFamily: "Regular",
            fontSize: 18,
          ),
          headlineMedium: TextStyle(
            fontFamily: "Minecraft",
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final String planks =
      "Praesent fringilla dapibus enim, sed sodales mi mattis id. Aliquam venenatis elementum sapien, vel facilisis orci volutpat vitae. Pellentesque viverra dui sed erat fringilla, ac faucibus sem pellentesque. Nam placerat et orci nec rutrum. Pellentesque ultricies tincidunt nisl, ac tempus ligula venenatis quis. Nunc nec tellus laoreet, tristique magna nec, feugiat odio. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TREES & WOOD",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Color(0x35353D00), // TO-DO Fix the color
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            child: SvgPicture.asset("assets/images/pickaxe.svg"),
          ),
        ),
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: const Icon(Icons.account_circle_rounded),
            // tooltip: 'Show Snackbar',
            // TO-DO make the button bring up a popup Dialog Box

            onPressed: () {
              showDialog(
                context: (context),
                builder: (context) {
                  return AlertDialog(
                    title: Text("ABOUT",
                        style: Theme.of(context).textTheme.headlineMedium),
                    content: Text(
                        "CREATED BY DOWER CHIN\n\nBASED ON THE WORK DONE IN 235'S DESIGN TO SPEC HOMEWORK.\n\nSEPTEMBER 2024",
                        style: Theme.of(context).textTheme.bodyMedium),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK",
                            style: Theme.of(context).textTheme.headlineMedium),
                      ),
                    ],
                  );
                },
                barrierDismissible: false,
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0x35353D00),
        child: SingleChildScrollView(
          child: Column(
              // TO-DO I think we can use the stack to set that image in the background to stay static
              children: [
                Column(
                  children: [
                    // TO-DO Using the folor filter change the backgrtound for the tree
                    // ColorFiltered(
                    //   colorFilter:
                    //       ColorFilter.mode(Colors.white, BlendMode.srcOut),
                    //   child: Image.asset("assets/images/oaktree.png"),
                    // ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 7)),
                      child: Image.asset('assets/images/oaktree.png'),
                    ),

                    // TO-DO add some padding to the text here, maybe just put it in its own text widget? probably something out there
                    Text(
                      "THE OAK TREE",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(planks),
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.green,
                      // child: ColorFiltered(
                      //   colorFilter:
                      //       ColorFilter.mode(Colors.blue, BlendMode.src,),
                      //   child: SvgPicture.asset("assets/images/pickaxe.svg"),
                      // ),
                    ),
                    Material(
                      color: const Color.fromARGB(255, 31, 16, 10),
                      child: InkWell(
                        onTap: () {
                          // add some button feature
                          showDialog(
                            context: (context),
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Planks",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                content: Container(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: Image.asset(
                                              'assets/images/planks.png'),
                                        ),
                                        Text(planks)
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("CLOSE",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium),
                                  ),
                                ],
                              );
                            },
                            barrierDismissible: false,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 7)),
                          child: Image.asset('assets/images/planks.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
              // child: Column(
              //   children: [Text('Hello World!')],
              // ),
              ),
        ),
      ),
    );
  }
}
