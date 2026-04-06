import 'package:flutter/material.dart';
import 'package:instproject/features/auth/presentation/components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('Study Group')),

        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       context.read<AuthCubit>().logout();
        //     },
        //     icon: Icon(Icons.logout),
        //   ),
        // ],
      ),
      drawer: MyDrawer(),
    );
  }
}
