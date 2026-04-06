import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instproject/features/auth/data/firebase_authrepo.dart';
import 'package:instproject/features/auth/data/fire_profile_repo.dart';
import 'package:instproject/features/auth/domain/repos/auth_repo.dart';
import 'package:instproject/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:instproject/features/auth/presentation/bloc/auth_states.dart';
import 'package:instproject/features/auth/presentation/bloc/profile_cubit.dart';
import 'package:instproject/features/auth/presentation/pages/auth_page.dart';
import 'package:instproject/features/chatgroup/cubit/chat_cubit.dart';
import 'package:instproject/features/chatgroup/cubit/group_cubit.dart';
import 'package:instproject/features/chatgroup/data/fire_chat_repo.dart';
import 'package:instproject/features/chatgroup/data/fire_group_repo.dart';
import 'package:instproject/features/chatgroup/pages/create_group_page.dart';
import 'package:instproject/features/posts/data/fire_post_repo.dart';
import 'package:instproject/features/posts/data/appwrite_storage_post_repo.dart';
import 'package:instproject/features/posts/domain/post_repo.dart';
import 'package:instproject/features/posts/presentation/bloc/post_cubit.dart';
import 'package:instproject/features/posts/presentation/pages/saved_posts_page.dart';
import 'package:instproject/features/posts/presentation/pages/search_posts.dart';
import 'package:instproject/features/storage/domain/storage_repo.dart';
import 'package:instproject/features/storage/domain/appwrite_storage_repo.dart';
import 'package:instproject/main_shell.dart';
import 'package:instproject/splash_screen.dart';
import 'package:instproject/themes/theme.dart';
import 'package:instproject/themes/theme_cubit.dart';

class MyApp extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;
  final authRepo = FirebaseAuthRepo();
  final profileRepo = FireProfileRepo();
  final storageRepo = AppwriteStorageRepo();
  final postRepo = FirePostRepo();
  final postStorageRepo = AppwritePostStorageRepo();
  final groupRepo = FireGroupRepo();
  final chatRepo = FireChatRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: firestore),
        RepositoryProvider<AuthRepo>.value(value: authRepo),
        RepositoryProvider<FireProfileRepo>.value(value: profileRepo),
        RepositoryProvider<StorageRepo>.value(value: storageRepo),
        RepositoryProvider<AppwriteStorageRepo>.value(value: storageRepo),
        RepositoryProvider<PostRepo>.value(value: postRepo),
        RepositoryProvider<AppwritePostStorageRepo>.value(
          value: postStorageRepo,
        ),
        RepositoryProvider.value(value: groupRepo),
        RepositoryProvider.value(value: chatRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthCubit(authRepo: authRepo)..checkAuth(),
          ),
          BlocProvider(
            create: (_) => ProfileCubit(
              profileRepo: profileRepo,
              storageRepo: storageRepo,
            ),
          ),
          BlocProvider(
            create: (_) =>
                PostCubit(postRepo: postRepo, storageRepo: postStorageRepo),
          ),
          
          BlocProvider(create: (_) => GroupCubit(groupRepo)..loadGroups()),
          BlocProvider(
            create: (_) => ChatCubit(repo: chatRepo, groupId: ''),
          ),
          BlocProvider(create: (_) => ThemeCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightMode,
              darkTheme: darkMode,
              themeMode: themeMode,
              routes: {
                '/auth': (context) => const AuthPage(),
                '/main': (context) => const MainShell(),
                '/splash': (context) => const SplashScreen(),
                '/search': (context) => const SearchPostsPage(),
                '/create_group': (context) => const CreateGroupPage(),
                '/save': (context) {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  return SavedPostsPage(userId: currentUser!.uid);
                },
              },
              home: BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is Unauthenticated) {
                    Future.microtask(() {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/auth', (route) => false);
                    });
                  } else if (state is Authenticated) {
                    Future.microtask(() {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/main', (route) => false);
                    });
                  }
                },
                child: const SplashScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
