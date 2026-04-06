import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/themes/theme_cubit.dart';

class ThemeSwitcherTile extends StatelessWidget {
  const ThemeSwitcherTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;
        return ListTile(
          leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
          title: Text(isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode'),
          trailing: Switch(
            value: isDark,
            onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
          ),
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
        );
      },
    );
  }
}
