import 'package:flutter/material.dart';
import 'preview.dart';

double saveSize = 0.0;
String savedText = "";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide()),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Text previewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _size = 10.0;
  final TextEditingController textController = TextEditingController();

  _onChangeSize(double value) {
    setState(() {
      _size = value;
      saveSize = value;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void saveText() {
    setState(() {
      savedText = textController.text;
    });
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: SizedBox(
            height: 50,
            child: Image.network(
              "https://emojiisland.com/cdn/shop/products/Robot_Emoji_Icon_abe1111a-1293-4668-bdf9-9ceb05cff58e_large.png?v=1571606090",
            ),
          ),
          content: SizedBox(
            height: 30,
            child: Text(
              (message),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => {Navigator.pop(context)},
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: "Text",
                  helperText: "Enter your text",
                ),
              ),

              Row(
                children: [
                  const Text("Font size: "),
                  Text(_size.toStringAsFixed(0)),
                  Slider(
                    value: _size,
                    min: 0,
                    max: 100,
                    onChanged: _onChangeSize,
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () async {
                  saveText();
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Preview()),
                  );

                  if (!context.mounted) return;
                  if (result == "ok") {
                    _showDialog(context, "Cool!");
                  } else if (result == "cancel") {
                    _showDialog(context, "Let’s try something else.");
                  } else {
                    _showDialog(context, "Don't know what to say.");
                  }
                },
                child: const Text("Preview"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
