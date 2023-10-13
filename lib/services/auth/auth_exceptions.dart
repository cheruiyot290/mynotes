// login exceptions
class InvalidLoginCredentialsException implements Exception{

}
class NetworkRequestFailedException implements Exception{

}
// register exceptions

class WeakPasswordException implements Exception{

}
class EmailAlreadyInUseException implements Exception{

}

// Which they both share
class MissingPasswordException implements Exception{

}
class ChannelErrorException implements Exception{

}
class InvalidEmailException implements Exception{

}
class INVALID_LOGIN_CREDENTIALS implements Exception{

}

// Generic exceptions

class GenericAuthException implements Exception{

}

// User not logged in exceptions
class UserNotLoggedIn implements Exception{

}
