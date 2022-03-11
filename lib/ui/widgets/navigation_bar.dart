import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
        IconButton(onPressed: (){}, icon: const Icon(Icons.home)),
        IconButton(onPressed: (){}, icon: const Icon(Icons.account_circle),)
      ],
    );
  }
}
