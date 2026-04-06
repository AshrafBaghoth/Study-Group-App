import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:instproject/features/auth/presentation/bloc/auth_states.dart';
import 'package:instproject/features/auth/presentation/components/my_button.dart';
import 'package:instproject/features/auth/presentation/components/my_textfiled.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController passCon = TextEditingController();
  final TextEditingController passConfirm = TextEditingController();

  bool isLoading = false;

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    final name = nameCon.text.trim();
    final email = emailCon.text.trim();
    final pass = passCon.text.trim();
    final confirm = passConfirm.text.trim();

    if (pass != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords don't match")));
      return;
    }

    context.read<AuthCubit>().register(name, email, pass);
  }

  @override
  void dispose() {
    nameCon.dispose();
    emailCon.dispose();
    passCon.dispose();
    passConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => isLoading = true);
        } else {
          setState(() => isLoading = false);
        }

        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, '/main');
        } else if (state is AuthErorr) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Image.asset('images/sg.png', width: 100, height: 100),
                  const SizedBox(height: 20),
                  const Text('Create Account', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 30),

                  MyTextfiled(
                    controller: nameCon,
                    hint: 'Your Name',
                    obsecure: false,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Please enter your name'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  MyTextfiled(
                    controller: emailCon,
                    hint: 'Enter your Email',
                    obsecure: false,
                    validator: (v) => v == null || !v.contains('@')
                        ? 'Enter valid email'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  MyTextfiled(
                    controller: passCon,
                    hint: 'Enter your Password',
                    obsecure: true,
                    validator: (v) =>
                        v == null || v.length < 6 ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 20),

                  MyTextfiled(
                    controller: passConfirm,
                    hint: 'Confirm your Password',
                    obsecure: true,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Please confirm password'
                        : null,
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: 200,
                    child: MyButton(
                      function: isLoading ? null : _register,
                      text: isLoading ? 'Loading...' : 'Sign Up',
                      minimumSize: const Size(140, 40),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      TextButton(
                        onPressed: widget.togglePages,
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
