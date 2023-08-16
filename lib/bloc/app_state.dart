import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/models.dart';

@immutable
class AppState {
  final bool isLoding;
  final LoginErrors? loginErrors;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState.empty()
      : isLoding = false,
        loginErrors = null,
        loginHandle = null,
        fetchedNotes = null;

  const AppState({
    required this.isLoding,
    required this.loginErrors,
    required this.loginHandle,
    required this.fetchedNotes,
  });

  @override
  String toString() => {
        'isLoding': isLoding,
        'loginErrors': loginErrors,
        'loginHandle': loginHandle,
        'fetchedNotes': fetchedNotes,
      }.toString();
}
