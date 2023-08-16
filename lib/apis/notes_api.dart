import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/models.dart';

@immutable
abstract class NotesApiProtocols {
  const NotesApiProtocols();
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  });
}

@immutable
class NotesApi implements NotesApiProtocols {
  @override
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandle == const LoginHandle.fooBar() ? mockNotes : null,
      );
}
