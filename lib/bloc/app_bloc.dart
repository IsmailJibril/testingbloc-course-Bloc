import 'package:bloc/bloc.dart';
import 'package:testingbloc_course/apis/login_api.dart';
import 'package:testingbloc_course/apis/notes_api.dart';
import 'package:testingbloc_course/bloc/actions.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocols notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        //! start loading
        emit(
          const AppState(
            isLoding: true,
            loginErrors: null,
            loginHandle: null,
            fetchedNotes: null,
          ),
        );
        //* log the user in
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );
        emit(
          AppState(
            isLoding: false,
            loginErrors: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      },
    );
    on<LoadNotesAction>(
      (event, emit) async {
        //! start loading
        emit(
          AppState(
            isLoding: true,
            loginErrors: null,
            loginHandle: state.loginHandle,
            fetchedNotes: null,
          ),
        );
        // get the login handle
        final loginHandle = state.loginHandle;
        if (loginHandle != const LoginHandle.fooBar()) {
          //* invalid login handle, cannot fetch notes
          emit(
            AppState(
              isLoding: false,
              loginErrors: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
              fetchedNotes: null,
            ),
          );
          return;
        }

        //we have valid login handle and want fetch notes

        final notes = await notesApi.getNotes(
          loginHandle: loginHandle!,
        );
        emit(
            AppState(
              isLoding: false,
              loginErrors: null,
              loginHandle: loginHandle,
              fetchedNotes: notes,
            ),
          );
      },
    );
  }
}
