
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/snackbar_message.dart';
import '../../domain/entities/auth.dart';
import '../blocs/authentication_bloc.dart';
import '../blocs/authentication_event.dart';
import '../blocs/authentication_state.dart';

class SignInCard extends StatefulWidget {

  const SignInCard({super.key});

  @override
  State<SignInCard> createState() => _SignInCardState();
}

class _SignInCardState extends State<SignInCard> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {

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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Text("Sign In", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
           const SizedBox(height: 32,),

           Form(
             key: _formKey,
             child: Column(
               children: [
                 ConstrainedBox(
                   constraints: BoxConstraints(
                     maxWidth: 500),
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
                 const SizedBox(height: 20,),
                 ConstrainedBox(
                   constraints: BoxConstraints(
                     maxWidth: 500,
                   ),

                   child: TextFormField(
                     controller: _passwordController,
                     obscureText: _obscureText? true : false,
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       labelText: 'Password',
                       suffixIcon: IconButton(
                         icon:  Icon(
                           _obscureText ? Icons.visibility_off : Icons.visibility,
                           color: Colors.grey,
                         ), onPressed: () {
                         setState(() {
                           _obscureText = !_obscureText;
                         });
                       },
                       ),
                     ),

                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return 'Please enter some text';
                       } else if (value.length < 7) {
                         return 'The password must contains more than seven characters.';
                       }
                       return null;
                     },
                   ),
                 ),
                 const SizedBox(height: 40,),
                 
                 BlocConsumer(builder: (context, state) {

                   if (state is FailureState) {
                     SnackBarMessage.showSnackBar(message: state.message, context: context);
                   }

                   return Column(
                     mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       ElevatedButton(
                         onPressed: () {
                           if (_formKey.currentState!.validate()) {
                             context.read<AuthenticationBloc>().add(
                                 UserSignInEvent(
                                   params: AuthParams(
                                       authProvider: AuthenticationProvider.emailPassword,
                                       credential: EmailAuthCredential(
                                           email: _emailController.text,
                                           password: _passwordController.text
                                       )
                                   ),
                                 )
                             );
                           }
                         },
                         style: ButtonStyle(
                           shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10.0),
                           )),
                           minimumSize: WidgetStateProperty.all(const Size(500, 50)),
                           textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 18)),
                         ),
                         child: const Text("Sign In"),
                       ),
                       const SizedBox(height: 20,),
                       if (state is LoadingState) const CircularProgressIndicator(),
                       Container(
                           margin: const EdgeInsets.all(20),
                           child:  Stack(
                             alignment: Alignment.center,
                             children: [
                               ConstrainedBox(
                                   constraints: const BoxConstraints(
                                       maxWidth: 500
                                   ),
                                   child: const Divider(thickness: 2,color: Colors.grey,)),
                               Positioned(
                                 child: Container(
                                   decoration: BoxDecoration(
                                       color: Colors.white,
                                       border: Border.all(color: Colors.black),
                                       borderRadius: BorderRadius.circular(15)
                                   ),
                                   padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 3),
                                   child: const Text(
                                     'OR',
                                     style: TextStyle(color: Colors.blue),
                                   ),
                                 ),
                               )
                             ],
                           )
                       ),
                       const SizedBox(height: 20,),
                       ElevatedButton(
                         onPressed: () {
                           context.read<AuthenticationBloc>().add(
                               UserSignInEvent(
                                 params: AuthParams(
                                     authProvider: AuthenticationProvider.google
                                 ),
                               )
                           );
                         },
                         style: ButtonStyle(
                           shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10.0),
                           )),
                           minimumSize: WidgetStateProperty.all(const Size(500, 50)),
                           textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 18)),
                         ),
                         child: const Text("Sign In with Google"),
                       ),
                       const SizedBox(height: 40,),
                       Row(
                         mainAxisSize: MainAxisSize.min,
                         children: [

                           const Text("Don't have an account?"),
                           TextButton(
                             onPressed: () {
                               context.read<AuthenticationBloc>().add(SignInPageEvent());
                             },
                             child: const Text("Sign Up", style: TextStyle(color: Colors.blue),),
                           ),
                           const SizedBox(width: 4,),
                           const Text("here"),
                         ],
                       ),
                       const SizedBox(height: 20,),
                     ]
                   );

                 }, listener: (context, state) {
                   if (state is UserSignedUpState) {
                     Navigator.of(context).pushNamed("/homePage");
                   }
                 }),
                 // const SizedBox(height: 20,),
                 ],),
               ),
          ],
        ),
      ),
    );
  }
}
