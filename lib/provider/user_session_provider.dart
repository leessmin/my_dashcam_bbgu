import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_dashcam/data/repositories/userSession/user_session_repository.dart';

final userSessionProvider = Provider((ref) => UserSessionRepository());
