import 'package:flutter/material.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/apis/login_api.dart';
import 'package:testingbloc_course/apis/notes_api.dart';
import 'package:testingbloc_course/bloc/actions.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/dialogs/generic_dialog.dart';
import 'package:testingbloc_course/dialogs/loading_screen.dart';
import 'package:testingbloc_course/models.dart';
import 'package:testingbloc_course/string.dart';
import 'package:testingbloc_course/views/iterable_list_view.dart';
import 'package:testingbloc_course/views/login_view.dart';

import 'bloc/app_state.dart';



void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        
        appBar: AppBar(
          centerTitle: true,
          title: const Text(homepage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appstate) {
            // Loading Screen
            if (appstate.isLoding) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            //? display possible errors
            final loginErrors = appstate.loginErrors;
            if (loginErrors != null) {
              showGenericDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }

            //! if we are logged in, but we have no fetched notes, fetch them row
            if (appstate.isLoding == false &&
                appstate.loginErrors == null &&
                appstate.loginHandle == const LoginHandle.fooBar() &&
                appstate.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
          builder: (context, appstate) {
            final notes = appstate.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
