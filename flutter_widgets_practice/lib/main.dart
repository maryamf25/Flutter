import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Widgets Practice',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Widgets Practice'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                'Hello, Flutter!',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Search something...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (value) {
                if (kDebugMode) {
                  print("User typed: $value");
                }
              },
            ),
            const SizedBox(height: 20),
            Center(
              child:
              const Text(
                'My Recipes',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.food_bank),
                SizedBox(width: 8),
                Text('Pancakes'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.food_bank),
                SizedBox(width: 8),
                Text('Omelette'),
              ],
            ),
            GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print("Card tapped!");
                }
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1587738347119-4d1c6c43d59e',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Pancakes',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

      LayoutBuilder(
        builder: (context, constraints) {
          int columns;

          if (constraints.maxWidth < 600) {
            columns = 1;
          } else if (constraints.maxWidth < 1024) {
            columns = 2;
          } else {
            columns = 4;
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3,
            ),
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Recipe ${index + 1}'),
                ),
              );
            },
          );
        },
      )
      ],
        ),
      ),
    );
  }
}
