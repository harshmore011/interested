import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../../../core/utils/snackbar_message.dart';
import '../../domain/entities/auth.dart';
import '../blocs/authentication_bloc.dart';
import '../blocs/authentication_event.dart';
import '../blocs/authentication_state.dart';

class SignUpCard extends StatefulWidget {

  final PersonRole personRole;

  const SignUpCard({super.key, required this.personRole});

  @override
  State<SignUpCard> createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  PersonRole? _personRole;

  @override
  void initState() {
    if(kDebugMode) {
      _emailController.text = 'Harshmore011@gmail.com';
      _passwordController.text = 'ThisIs@123';
    }
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SignUpCard oldWidget) {
    _personRole = widget.personRole;
    logger.log("SignUpCard: didUpdateWidget", "personRole: $_personRole");
    logger.log("SignUpCard: didUpdateWidget", "old personRole: ${oldWidget.personRole}");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {

    _personRole = widget.personRole;
    logger.log("SignUpCard: initState", "personRole: $_personRole");

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.white,
      elevation: 4,
      child: Container(
        // width: 275,
        // height: 400,
        // constraints: BoxConstraints(maxHeight: ),
        padding: const EdgeInsets.only(left: 32, right: 32, top: 32, bottom: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_personRole == PersonRole.user || _personRole == PersonRole.anonymous
                ? "User Sign Up" :
              "Publisher Sign Up",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 32,
            ),
            BlocConsumer<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  logger.log("SignUpCard: build","current state: ${state.runtimeType}");

              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'E-mail',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your E-mail';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConstrainedBox(
                      constraints:const  BoxConstraints(
                        maxWidth: 300,
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText ? true : false,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 7) {
                            return 'Password must be more than 7 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {

                              AuthenticationEvent event;
                              AuthParams params = AuthParams(
                                  authProvider: AuthenticationProvider
                                      .emailPassword,
                                  credential: EmailAuthCredential(
                                      email: _emailController.text,
                                      password:
                                      _passwordController.text));

                              if (_personRole == PersonRole.anonymous) {
                                event = AnonymousToUserEvent(
                                  params: params,
                                );
                              } else if (_personRole == PersonRole.user) {
                                event = UserSignUpEvent(
                                  params: params,
                                );
                              } else {
                                event = PublisherSignUpEvent(params: params);
                              }

                              context
                                  .read<AuthenticationBloc>()
                                  .add(event);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                AppTheme.colorPrimary),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                            minimumSize:
                                WidgetStateProperty.all(const Size(300, 50)),
                            textStyle: WidgetStateProperty.all(
                                const TextStyle(fontSize: 18,)),
                          ),
                          child: const Text("Sign Up",
                          style: TextStyle(color: Colors.white,),),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (state is LoadingState)
                          const CircularProgressIndicator(),
                        Container(
                            margin: const EdgeInsets.all(20),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 300),
                                    child: const Divider(
                                      thickness: 2,
                                      color: Colors.grey,
                                    )),
                                Positioned(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: const Text(
                                      'OR',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        if(_personRole == PersonRole.user)
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<AuthenticationBloc>()
                                .add(AnonymousSignInEvent());
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                                // WidgetStateProperty.all(AppTheme.colorPrimary),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                            minimumSize:
                                WidgetStateProperty.all(const Size(300, 50)),
                            textStyle: WidgetStateProperty.all(
                                const TextStyle(fontSize: 18)),
                          ),
                          child: const Text("Continue as Guest", style:
                            // TextStyle(color: Colors.white),),
                            TextStyle(color: AppTheme.colorPrimary),),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            AuthenticationEvent event;
                            AuthParams params = AuthParams(
                                authProvider: AuthenticationProvider
                                    .google,);

                            if (_personRole == PersonRole.anonymous) {
                              event = AnonymousToUserEvent(
                                params: params,
                              );
                            } else if (_personRole == PersonRole.user) {
                              event = UserSignUpEvent(
                                params: params,
                              );
                            } else {
                              event = PublisherSignUpEvent(params: params);
                            }

                            context
                                .read<AuthenticationBloc>()
                                .add(event);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                          WidgetStateProperty.all(AppTheme.colorPrimary),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                            minimumSize:
                                WidgetStateProperty.all(const Size(300, 50)),
                            textStyle: WidgetStateProperty.all(
                                const TextStyle(fontSize: 18,)),
                          ),
                          child: const Text("Sign Up with Google",
                          style: TextStyle(color: Colors.white),),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Existing User?"),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<AuthenticationBloc>()
                                    .add(SignInPageEvent());
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text("instead"),
                          ],
                        ),
                      ],
                    ),

                    // const SizedBox(height: 20,),
                  ],
                ),
              );
            }, buildWhen: (previous, current) {
              return current is LoadingState || current is FailureState;
            }
            , listener: (context, state) {
              logger.log("SignInCard: LISTENER","current state: ${state.runtimeType}");

              if (state is AnonymousSignedInState ||
                  state is AnonymousLinkedToUserState ||
                  state is UserSignedUpState) {
                Navigator.of(context).pushNamed("/homePage");
              } else if (state is PublisherSignedUpState) {
                Navigator.of(context).pushNamed("/publisherHomePage");
              } else if (state is FailureState) {
                SnackBarMessage.showSnackBar(
                    message: state.message, context: context);
              }
            },
              listenWhen: (previous, current) {
                /*return current is !SignInPageState ||
                  current is !SignUpPageState ||
                  current is !SignedOutState;*/
                return current is UserSignedUpState ||
                    current is PublisherSignedUpState ||
                    current is AnonymousLinkedToUserState ||
                    current is AnonymousSignedInState ||
                    current is FailureState;
              }
            ),
          ],
        ),
      ),
    );
  }
}
