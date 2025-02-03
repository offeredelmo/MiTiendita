
abstract class Failure {
  
}

class ServerFailure extends Failure {
  
}

class LocalFailure extends Failure {
  final String? message;

  LocalFailure({this.message});
}
