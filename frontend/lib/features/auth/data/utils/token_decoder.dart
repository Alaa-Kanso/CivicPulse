import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenDecoder {
  static User decode(String token) {
    final decoded = JwtDecoder.decode(token);
    return User(
      id: decoded['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'],
      email: decoded['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'],
      role: decoded['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'],
    );
  }
}