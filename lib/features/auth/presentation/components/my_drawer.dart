import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:instproject/features/auth/presentation/components/mydrawer_tail.dart';
import 'package:instproject/themes/theme_mode_switcher.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: ListView(
            children: [
              
              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              Divider(color: Theme.of(context).colorScheme.secondary),

              MydrawerTail(
                title: 'Favorites',
                icon: Icons.bookmark,
                onTap: () => Navigator.pushNamed(context, '/save'),
              ),

              const ThemeSwitcherTile(),

              MydrawerTail(
                title: 'LogOut',
                icon: Icons.logout,
                onTap: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
