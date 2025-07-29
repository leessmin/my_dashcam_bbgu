import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/data/repositories/loginRegister/login_register_repository.dart';

final loginRegisterProvider = Provider((ref) => LoginRegisterRepository());
