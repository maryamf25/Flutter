import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_page_provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final counterProvider = Provider.of<HomePageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("State Management Practice"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "Counter Value: ${counterProvider.counter}",
              style: const TextStyle(fontSize: 24),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: counterProvider.increment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Increment"),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: counterProvider.decrement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    child: const Text("Decrement"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
