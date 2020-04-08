import 'dart:async';
import 'validators.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/fetch.dart';

class Bloc extends Object with Validators {
  final _emailCtr = new BehaviorSubject<String>();
  final _passCtr = new BehaviorSubject<String>();

// add date to stream
  Stream<String> get email => _emailCtr.stream.transform(validateEmail);
  Stream<String> get password => _passCtr.stream.transform(validatePassword);
  Stream<bool> get submitValid =>
      Rx.combineLatest2(email, password, (e, p) => true);

//change item
  Function(String) get changeEmail => _emailCtr.sink.add;
  Function(String) get changePassword => _passCtr.sink.add;

  submit() {
    final email = _emailCtr.value;
    final password = _passCtr.value;

    print("email: $email");
    print("password: $password");

    const String loginQuery = r'''
 query {
  protected {
    message
  }
}

''';

    FetchFromSTGWithGraphql().fetchGraphql(loginQuery);
  }

  dispose() {
    _emailCtr.close();
    _passCtr.close();
  }
}

final bloc = Bloc();
