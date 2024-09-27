import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Color Changer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Color Changer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _backgroundColor = Colors.white;
  Color _previousColor = Colors.white; 
  final TextEditingController _controller = TextEditingController();

  void _changeBackgroundColor(String colorName) {
    setState(() {
      _previousColor = _backgroundColor; 
      _backgroundColor = _getColorFromName(colorName);
      if (_backgroundColor == Colors.grey) {
        _showSnackBar("Color '$colorName' not recognized. Defaulting to grey.");
      }
    });
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.grey; 
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ColoredBox(
        color: _backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Enter a color name to change the background:'),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Color name',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: _changeBackgroundColor,  
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Previous Color:',
                style: TextStyle(fontSize: 16),
              ),
              Container(
                width: 100,
                height: 100,
                color: _previousColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
