/// This library acts as a small wrapper around the [taskc] library, to
/// implement a notion of [Storage] of tasks consistent with a method to
/// synchronize tasks with a
/// [Taskserver](https://github.com/GothenburgBitFactory/taskserver).

library storage;

export 'src/storage/bad_certificate_exception.dart';
export 'src/storage/storage.dart';
export 'src/storage/taskserver_configuration_exception.dart';
