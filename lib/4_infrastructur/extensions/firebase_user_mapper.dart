import 'package:firebase_auth/firebase_auth.dart';

import '../../3_domain/entities/id.dart';
import '../../3_domain/entities/user.dart';

extension FirebaseUserMapper on User {
  CustomUser toDomain() {
    return CustomUser(id: UniqueID.fromUniqueString(uid));
  }
}
