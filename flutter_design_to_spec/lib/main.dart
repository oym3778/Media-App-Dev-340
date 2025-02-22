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
            color: Colors.white,
            fontFamily: "Regular",
            fontSize: 18,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontFamily: "Minecraft",
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            color: Colors.white,
            fontFamily: "Minecraft",
            fontSize: 15,
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
  final String itemText =
      "Praesent fringilla dapibus enim, sed sodales mi mattis id. Aliquam venenatis elementum sapien, vel facilisis orci volutpat vitae. Pellentesque viverra dui sed erat fringilla, ac faucibus sem pellentesque. Nam placerat et orci nec rutrum. Pellentesque ultricies tincidunt nisl, ac tempus ligula venenatis quis. Nunc nec tellus laoreet, tristique magna nec, feugiat odio. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;";
  static const Color mainBackground = Color(0xFF35353D);
  static const Color appBar = Color(0xFFA19FA2);
  static const Color textBorder = Color(0xFFFFFFFF);
  static const Color gradientDark = Color(0xFF374947);
  static const Color gradientLight = Color(0xFF828C8E);
  static const Color itemBackground = Color(0xFF324D44);
  static const Color textAreas = Color(0xFF686868);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TREES & WOOD",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: appBar, // TO-DO Fix the color
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(textBorder, BlendMode.srcIn),
            child: SvgPicture.asset("assets/images/pickaxe.svg"),
          ),
        ),
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              showDialog(
                context: (context),
                builder: (context) {
                  return AlertDialog(
                    title: Text("ABOUT",
                        style: Theme.of(context)
                            .textTheme
                            .apply(displayColor: Colors.black)
                            .headlineMedium),
                    content: Text(
                        "CREATED BY OMAR MORALES-SAEZ\n\nBASED ON THE WORK DONE IN 235'S DESIGN TO SPEC HOMEWORK.\n\nSEPTEMBER 2024",
                        style: Theme.of(context)
                            .textTheme
                            .apply(bodyColor: Colors.black)
                            .bodyMedium),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK",
                            style: Theme.of(context)
                                .textTheme
                                .apply(displayColor: Colors.purple[200])
                                .headlineMedium),
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
      body: Stack(
        children: [
          Image.asset(
              fit: BoxFit.cover,
              height: double.infinity,
              'assets/images/valley.jpg'),
          SingleChildScrollView(
            child: Column(
              children: [
                Column(children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              gradientDark,
                              gradientLight,
                            ],
                          ),
                          // color: gradientDark, //TO-DO CHANGE COLOR
                          border: Border.all(
                            color: textBorder,
                            width: 7,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Image.asset('assets/images/oaktree.png'),
                        ),
                      ),

                      // TO-DO add some padding to the text here, maybe just put it in its own text widget? probably something out there
                      Container(
                        color: textAreas, //TO-DO CHANGE COLOR
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "THE OAK TREE", // to-do align the text to the left
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.headlineMedium,
                                  ),
                                ),
                              ),
                              Text(itemText),
                            ],
                          ),
                        ),
                      ),
                      // used to create some space to show the background
                      SizedBox(
                        width: double.infinity,
                        height: 350,
                      ),
                      Container(
                        color: mainBackground,
                        child: Column(
                          spacing: 10,
                          children: [
                            itemContainer(
                              context,
                              'assets/images/planks.png',
                              'PLANKS',
                            ),
                            itemContainer(
                              context,
                              'assets/images/stick.png',
                              'STICKS',
                            ),
                            itemContainer(
                              context,
                              'assets/images/chest.png',
                              'CHESTS',
                            ),
                            itemContainer(
                              context,
                              'assets/images/stairs.png',
                              'STAIRS',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding itemContainer(BuildContext context, String image, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: textAreas,
        width: double.infinity,
        height: 200,
        child: Row(
          children: [
            Material(
              color: itemBackground,
              child: InkWell(
                onTap: () {
                  // add some button feature
                  showDialog(
                    context: (context),
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: textAreas,
                        title: Text(title,
                            style: Theme.of(context).textTheme.headlineMedium),
                        content: Container(
                          color: textBorder,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: itemBackground,
                                  border:
                                      Border.all(width: 10, color: textBorder),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(image),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(itemText,
                                            overflow: TextOverflow.fade,
                                            style: Theme.of(context)
                                                .textTheme
                                                .apply(bodyColor: Colors.black)
                                                .bodyMedium),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
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
                                    .apply(displayColor: Colors.purple[200])
                                    .headlineMedium),
                          ),
                        ],
                      );
                    },
                    barrierDismissible: false,
                  );
                },
                child: Container(
                  width: 170,
                  decoration: BoxDecoration(
                      border: Border.all(color: textBorder, width: 7)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      spacing: 10,
                      children: [
                        Text(title,
                            style: Theme.of(context).textTheme.headlineSmall),
                        Image.asset(image),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // EXPANDED prevents the text from overflowinng to the right of the screen
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    itemText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
