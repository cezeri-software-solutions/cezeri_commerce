abstract class AuthFailure {}

// ############### SignIn Failures #################

class WrongPasswordFailure extends AuthFailure {}

class UserDisabledFailure extends AuthFailure {}

class InvalidEmailFailure extends AuthFailure {}

// ############### Register Failures #################

class EmailAlreadyInUseFailure extends AuthFailure {}

class WeakPasswordFailure extends AuthFailure {}

// ############### SignIn & Register Failures #################

class EmailNotFoundFailure extends AuthFailure {}

class AuthServerFailure extends AuthFailure {}
