import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unlockable Rewards')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: List.generate(5, (i) {
          return Card(
            child: ListTile(
              title: Text('Reward ${i + 1}'),
              subtitle: Text('${(i + 1) * 100} pts required'),
              trailing: ElevatedButton(onPressed: () {}, child: const Text('Redeem')),
            ),
          );
        }),
      ),
    );
  }
}
