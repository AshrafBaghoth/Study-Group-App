import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:instproject/features/auth/presentation/bloc/auth_states.dart';
import 'package:instproject/features/auth/presentation/components/my_button.dart';
import 'package:instproject/features/auth/presentation/components/my_textfiled.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final pass = _passController.text.trim();
      context.read<AuthCubit>().login(email, pass);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthErorr) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'images/sg.png',
                        width: 100,
                        height: 100,
                      ),
                    ),

                    const SizedBox(height: 40),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                    const SizedBox(height: 5),
                    

                    const SizedBox(height: 30),

                    
                    MyTextfiled(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      controller: _emailController,
                      hint: 'Enter your Email',
                      obsecure: false,
                    ),

                    const SizedBox(height: 20),

                    
                    MyTextfiled(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      controller: _passController,
                      hint: 'Enter your Password',
                      obsecure: true,
                    ),

                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: TextButton(
                    //     onPressed: () {},
                    //     child: const Text('Forgot Password?'),
                    //   ),
                    // ),

                    const SizedBox(height: 20),

                    
                    SizedBox(
                      width: 200,
                      child: MyButton(
                        function: isLoading ? null : _login,
                        text: isLoading ? 'Loading...' : 'Login',
                        minimumSize: const Size(140, 40),
                      ),
                    ),

                    const SizedBox(height: 20),

                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don’t have an account?'),
                        TextButton(
                          onPressed: widget.togglePages,
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.brown),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
